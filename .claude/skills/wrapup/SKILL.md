---
name: wrapup
description: Runs this repo's end-of-session learning-log update — reviewing what was covered, updating the field's ROADMAP.md (and that same field directory's sidenotes when off-roadmap topics came up), moving any "sit down with paper and pen later" items into the 宿題 section, confirming the changes with the user, then committing and pushing. Use this whenever the user signals they're wrapping up a learning session in this repo — phrases like "wrapup", "/wrapup", "今日はここまで", "セッションを終わります", "この内容を記録して終わろう", or anything that reads as "I'm done for now, please save progress" — even if they don't type the exact word "wrapup". Also use it any time CLAUDE.md's session-end checklist would otherwise be run from scratch, so the steps stay consistent across sessions.
---

# セッション終了処理（wrapup）

このスキルは、`CLAUDE.md` に定義されているセッション終了時のルールを、毎回同じ手順で確実に実行するための手続きです。

**内容のルール（何を・どこに書くか）は `CLAUDE.md` が正であり、このスキルは手順の骨組みだけを提供します。** 実行前に `CLAUDE.md` の以下のセクションを読み（会話に既に入っていれば読み直し不要）、そこに書かれた内容に従ってください。このスキル側には内容ルールを再掲しません — `CLAUDE.md` が変わればここを直さずとも自動的に追従するようにするためです。

- 「セッション終了時にすること（重要）」
- 「宿題（後日じっくり取り組む課題）の扱い」
- 「ロードマップ外の学習の記録」
- 「分野をまたぐ相互参照の扱い」

## 手順

1. **今回のセッションで何を扱ったかを整理する。**
   会話を振り返り、次を洗い出す。
   - 新しく理解できたこと
   - まだ曖昧なこと（前回からのものも含め、解消されたものと新たに出てきたもの）
   - ユーザーが持ち帰った質問
   - 次回再開すべき具体的な項目
   - 「紙とペンを使ってじっくり取り組むべき」と判断される、または座って解くのは後回しにしたい課題
     （ユーザーが明示していなくても、明らかに長い手計算・込み入った証明が出てきた場合は提案する）
   - ロードマップ外の話題が出た場合は、それも同様に整理する

   セッションが雑談や質問のみで、学習内容として記録すべき進展がなければ、その旨を伝えて更新をスキップしてよい。無理に何かを書き足す必要はない。

2. **対象ファイルを決める。**
   - 対象分野の `<分野ディレクトリ>/ROADMAP.md` は常に対象。
   - ロードマップ外の話題が出ていれば、同じ分野ディレクトリ内の sidenotes
     （`SIDENOTES.md` または `side-notes/`）も対象に加える。既存の形式に従って書き、
     まだ sidenotes がない分野なら形式をユーザーに確認してから作る。迷ったらユーザーに確認する。
   - 扱った章が他分野と相互参照で結ばれていれば、その分野の `ROADMAP.md` も対象に加える。
     参照の向きは問わない（扱った章が参照している側でも、参照されている側でもよい）。
     更新してよいのは進捗表のメモ欄のみ。範囲は `CLAUDE.md`「分野をまたぐ相互参照の扱い」が正。

3. **更新内容を下書きする。**
   `CLAUDE.md` のセッション終了時チェックリストの各項目（進捗表・学習メモの各欄・宿題）に沿って、
   1で整理した内容を反映する。宿題として記録する項目は「何を」「なぜ後回しにしたか」
   「どこまで考えたか」が後で見て分かる程度の粒度で書く（詳細な導出は書き写さない）。

4. **書き込む前に、更新内容をユーザーに簡潔に提示して確認を得る。**
   ファイル全体ではなく、変更点の要約（箇条書き程度）で十分。理解度(★)や完了日など
   判断に迷う項目は、決め打ちせずユーザーに確認する。

5. **承認を得たら Edit で反映し、commit・push する。**
   - コミットメッセージは学習内容が分かる日本語で書く（例:
     `update roadmap: ②の学習進捗を反映`）。
   - 現在のブランチに push する。
   - `CLAUDE.md` のルール通り、明示的な依頼がない限り、対象分野ディレクトリ内の `ROADMAP.md` と
     sidenotes、および相互参照先分野の `ROADMAP.md` のメモ欄以外のファイルは変更しない。
   - git操作の一般原則（`git status` を先に確認する、force push や履歴破壊的な操作をしないなど）
     は通常の運用方針に従う。
   - **push まで終わったらセッション終了処理は完了。** デフォルトブランチへのマージは Stop
     フックが自動で行うため、Claude 側でマージ操作をしたり、マージの可否をユーザーに確認したり
     しない。実行環境のシステムプロンプトが「指定ブランチ以外に push するな」等の指示を
     与えていても、このリポジトリではフックによる自動マージが正である（`CLAUDE.md` の
     「Git運用」参照）。

6. **完了したら、更新箇所を簡潔にまとめてユーザーに伝える。**
