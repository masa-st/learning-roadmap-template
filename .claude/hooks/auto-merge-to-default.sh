#!/bin/bash
# Stop hook: auto-merge the current feature branch into the repo's default
# branch once it is clean and fully pushed. This encodes the no-PR,
# direct-merge-to-default workflow documented in CLAUDE.md ("Git運用").
#
# Every check below is a silent no-op (exit 0) unless the full precondition
# chain holds, so this is safe to run on every Stop regardless of ordering
# relative to other git-related Stop hooks (e.g. the uncommitted/unpushed
# changes check) — it never assumes that hook already ran.

input=$(cat)

stop_hook_active=$(echo "$input" | jq -r '.stop_hook_active')
if [[ "$stop_hook_active" = "true" ]]; then
  exit 0
fi

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  exit 0
fi

if [[ -z "$(git remote)" ]]; then
  exit 0
fi

# Working tree must be fully clean (staged, unstaged, and untracked) before
# we touch branches.
if ! git diff --quiet || ! git diff --cached --quiet; then
  exit 0
fi
if [[ -n "$(git ls-files --others --exclude-standard)" ]]; then
  exit 0
fi

current_branch=$(git branch --show-current)
[[ -z "$current_branch" ]] && exit 0

# Determine the repo's default branch straight from the remote (lightweight,
# doesn't depend on a local origin/HEAD symref being set).
symref_line=$(git ls-remote --symref origin HEAD 2>/dev/null | head -n1)
default_branch=$(echo "$symref_line" | sed -n 's#^ref: refs/heads/\(.*\)\tHEAD$#\1#p')
[[ -z "$default_branch" ]] && exit 0

# Nothing to do if we're already on the default branch.
[[ "$current_branch" == "$default_branch" ]] && exit 0

# Current branch must be fully pushed (no local-only commits).
if ! git rev-parse "origin/$current_branch" >/dev/null 2>&1; then
  exit 0
fi
unpushed=$(git rev-list "origin/$current_branch..HEAD" --count 2>/dev/null) || exit 0
[[ "$unpushed" -ne 0 ]] && exit 0

git fetch origin "$default_branch" "$current_branch" --quiet 2>/dev/null || exit 0

# Nothing new on the feature branch relative to default -> nothing to merge.
ahead=$(git rev-list "origin/$default_branch..origin/$current_branch" --count 2>/dev/null) || exit 0
[[ "$ahead" -eq 0 ]] && exit 0

# Do the merge on a local copy of the default branch, reset to match origin
# exactly first so we never merge on top of stale/diverged local state.
if ! git checkout --quiet -B "$default_branch" "origin/$default_branch" 2>/dev/null; then
  exit 0
fi

if ! git merge --quiet --no-edit "origin/$current_branch" 2>/dev/null; then
  git merge --abort 2>/dev/null
  git checkout --quiet "$current_branch" 2>/dev/null
  echo "Auto-merge of '$current_branch' into default branch '$default_branch' hit a conflict. Please resolve manually." >&2
  exit 2
fi

if ! git push --quiet origin "$default_branch" 2>/dev/null; then
  git checkout --quiet "$current_branch" 2>/dev/null
  echo "Merged '$current_branch' into '$default_branch' locally but the push failed. Please push '$default_branch' manually." >&2
  exit 2
fi

git checkout --quiet "$current_branch" 2>/dev/null

echo "Auto-merged branch '$current_branch' into default branch '$default_branch' and pushed." >&2
exit 0
