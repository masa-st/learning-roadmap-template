# learning-roadmap-template — Claude を家庭教師にする学習リポジトリのテンプレート

Claude と対話しながら任意の分野を学ぶためのリポジトリのテンプレートです。
分野ごとにディレクトリを作り、各ディレクトリ直下の `ROADMAP.md` がその分野の学習状態
（章立て・到達目標・進捗・学習メモ）を保持します。セッションをまたいで `ROADMAP.md` が
更新され続けることで、「前回の続きから再開できる専属家庭教師」として Claude を使えます。

## はじめ方

1. **このテンプレートから自分のリポジトリを作る** — このリポジトリの GitHub ページで
   **Use this template → Create a new repository** を選ぶ（学習記録には個人の内容が
   含まれるので Private 推奨）。
   - このボタンが出ない場合、リポジトリ所有者が **Settings → General → Template repository**
     にチェックを入れると有効になります。fork や clone → push でも構いません。
2. **Claude から開けるようにする** — スマホの Claude アプリから使う場合は
   [`MOBILE_SETUP.md`](./MOBILE_SETUP.md) の手順で Claude GitHub App を連携する
   （PC の Claude Code CLI で clone して使ってもよい）。
3. **最初のロードマップを作る** — セッションを開始して「○○を学びたい」と伝えると、
   `create-roadmap` スキルが学びたい分野・学ぶ動機（目指す方向性）・現在の知識レベルを
   ヒアリングし、対話でロードマップ（`<分野ディレクトリ>/ROADMAP.md`）を作ります。
   見本の [`statistics-certificate-pre1/`](./statistics-certificate-pre1/ROADMAP.md)
   （統計検定準1級）をそのまま使う場合はこの手順は不要です。使わないなら削除して構いません。
4. **学習する** — 「①の続きから」などと伝えれば、Claude が `CLAUDE.md` の指示に従って
   対象分野の `ROADMAP.md` を読み、前回の続きから対話形式で学習を進めます。
5. **セッションを終える** — 「今日はここまで」や `/wrapup` と伝えると、その回の学習内容が
   `ROADMAP.md` の進捗表・学習メモに反映され、commit・push まで自動で行われます。
   次回は 4. に戻るだけです。

## 構成

- [`CLAUDE.md`](./CLAUDE.md) — Claude 向けの運用ルール。セッション開始時にどの分野を学ぶか
  確認し、対象分野の `ROADMAP.md` の進捗を読んで再開地点を確認、終了時に同ファイルを更新して
  commit・push することを定めています。宿題の扱い、ロードマップ外の学習の記録先（sidenotes）、
  分野をまたぐ相互参照、Markdown に数式を書くときのルールもここにあります。
- [`templates/ROADMAP_TEMPLATE.md`](./templates/ROADMAP_TEMPLATE.md) — ロードマップの雛形。
  `create-roadmap` スキルがこの構成でロードマップを生成します。手で書く場合の参考にもなります。
- [`statistics-certificate-pre1/`](./statistics-certificate-pre1/ROADMAP.md) — 記入見本を兼ねた
  実物のロードマップ（統計検定2級レベルの知識を前提に準1級合格を目指す）。
  そのまま使っても、削除して自分の分野に差し替えてもよい。
- `.claude/` — Claude Code 用の設定一式。
  - `skills/create-roadmap/` — 新しい分野のロードマップをヒアリングから対話で作るスキル
  - `skills/wrapup/` — セッション終了処理（進捗反映 → 確認 → commit・push）のスキル
  - `hooks/check-uncommitted.sh` — 未コミット・未 push の変更を残したままセッションを
    終われないようにする Stop フック
  - `hooks/auto-merge-to-default.sh` — push 済みの作業ブランチをデフォルトブランチへ
    自動マージする Stop フック（このリポジトリの運用では PR を作りません。
    詳細は `CLAUDE.md` の「Git運用」）
  - `settings.json` — 上記フックの登録と、commit・push の許可設定
- [`MOBILE_SETUP.md`](./MOBILE_SETUP.md) — **スマホの Claude アプリから使う場合は先に
  読んでください。** Claude GitHub App の入れ方、セッションの始め方・終わり方、
  このテンプレート固有の Git 運用をスクリーンショット付きでまとめています。
- [`VSCODE_SETUP.md`](./VSCODE_SETUP.md) — **VS Code でこのリポジトリを開く場合は先に
  読んでください。** 数式を GitHub 仕様（math フェンス）で書いているため、標準プレビューだと
  数式がソース表示になります。拡張機能 1 つで解消できます。

## 分野一覧

<!-- create-roadmap スキルが新しい分野を作るたびに、ここに 1 行追加します。 -->

- [`statistics-certificate-pre1/`](./statistics-certificate-pre1/ROADMAP.md) — 統計検定準1級
  （2級レベルの知識を前提に準1級合格を目指す。テンプレート同梱の見本）

## このテンプレートの運用の特徴

- **ロードマップが学習の状態そのもの** — 各 `ROADMAP.md` の「学習進捗」表と「学習メモ」
  （理解できたこと／曖昧なこと／次回学ぶ内容／宿題など）が唯一の記録であり、
  セッションをまたいで更新され続けます。
- **脱線も記録される** — ロードマップの正統カリキュラムから外れた話題は、そのとき学習していた
  分野のディレクトリ内の sidenotes（`SIDENOTES.md` または `side-notes/`）に記録されます。
- **宿題の運用** — スキマ時間の学習では長い手計算・証明をその場でこなせないため、
  そうした課題は「宿題」としてメモに残し、後日紙とペンで取り組めます。
- **Git 操作は意識しなくてよい** — セッション終了時の commit・push、デフォルトブランチへの
  マージまでスキルとフックで自動化されています。push 忘れによる記録の消失も
  フックがブロックします。
