#!/bin/bash
# Stop hook: block ending a session in this repo with unsaved learning-log
# changes (uncommitted, untracked, or unpushed), per CLAUDE.md's
# session-end checklist.

# VS Code 拡張から起動されたセッションではこのフックを無効化する（任意の運用。
# 詳細と外し方は VSCODE_SETUP.md「VS Code で開いたセッションの扱い」）。
# スマホ/デスクトップ/web の Claude アプリやターミナル（CLAUDE_CODE_ENTRYPOINT が
# claude-vscode 以外）では従来どおり有効。値は実測に基づく（将来アプリ更新で
# 変わる可能性はあるが、その場合はこの条件を直すだけでよい）。
if [[ "$CLAUDE_CODE_ENTRYPOINT" == "claude-vscode" ]]; then
  exit 0
fi

# Recursion prevention
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

if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "There are uncommitted changes in the repository. Please commit and push these changes to the remote branch." >&2
  exit 2
fi

untracked_files=$(git ls-files --others --exclude-standard)
if [[ -n "$untracked_files" ]]; then
  echo "There are untracked files in the repository. Please commit and push these changes to the remote branch." >&2
  exit 2
fi

current_branch=$(git branch --show-current)
if [[ -n "$current_branch" ]]; then
  if git rev-parse "origin/$current_branch" >/dev/null 2>&1; then
    upstream="origin/$current_branch"
  else
    upstream="origin/HEAD"
  fi

  unpushed=$(git rev-list "$upstream..HEAD" --count 2>/dev/null) || unpushed=0
  if [[ "$unpushed" -gt 0 ]]; then
    if [[ "$upstream" == "origin/$current_branch" ]]; then
      echo "There are $unpushed unpushed commit(s) on branch '$current_branch'. Please push these changes to the remote repository." >&2
    else
      echo "Branch '$current_branch' has $unpushed unpushed commit(s) and no remote branch. Please push these changes to the remote repository." >&2
    fi
    exit 2
  fi
fi

exit 0
