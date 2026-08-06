# learning-roadmap-template — Claude を家庭教師にする学習リポジトリのテンプレート

Claude と対話しながら任意の分野を学ぶためのリポジトリのテンプレートです。
分野ごとにディレクトリを作り、各ディレクトリ直下の `ROADMAP.md` がその分野の学習状態
（章立て・到達目標・進捗・学習メモ）を保持します。セッションをまたいで `ROADMAP.md` が
更新され続けることで、「前回の続きから再開できる専属家庭教師」として Claude を使えます。

## 必要なもの

- **GitHub アカウント**（無料プランで構いません）
- **Claude Code が使えるプラン** — Pro または Max（Team / Enterprise でも構いません）
- 次のどちらかの利用環境
  - **スマホ / タブレット** — Claude アプリの「コード」から使う（設定は [`MOBILE_SETUP.md`](./MOBILE_SETUP.md)）
  - **PC** — Claude Code CLI でリポジトリを clone して使う

学習記録には理解度や個人的なメモが残るため、作るリポジトリは **Private 推奨** です。
Private にした場合、Claude GitHub App 側でそのリポジトリへのアクセスを明示的に
許可する必要があります（手順は [`MOBILE_SETUP.md`](./MOBILE_SETUP.md) の 3 章）。

## はじめ方

**各手順の詳細は [`GETTING_STARTED.md`](./GETTING_STARTED.md) にあります。**
テンプレートからの複製手順、見本ディレクトリの扱い、うまくいかないときの対処まで
まとめてあるので、まずはそちらを読んでください。以下は流れの要約です。

1. **このテンプレートから自分のリポジトリを作る** — **Use this template →
   Create a new repository**（Private 推奨）。
2. **Claude から開けるようにする** — スマホの Claude アプリなら Claude GitHub App を
   連携する。PC なら clone して Claude Code CLI で開く。
3. **最初のロードマップを作る** — 「○○を学びたい」と伝えると、`create-roadmap` スキルが
   ヒアリングしながら `<分野ディレクトリ>/ROADMAP.md` を作ります。
4. **学習して、記録して終える** — 「①の続きから」で再開し、「今日はここまで」や
   `/wrapup` で進捗の記録・commit・push まで自動で行われます。

## 構成

- [`GETTING_STARTED.md`](./GETTING_STARTED.md) — **最初に読んでください。** このテンプレートから
  自分のリポジトリを作り（Use this template）、Claude と連携し、最初の学習セッションを
  始めるまでの手順書です。fork との違い、GitHub CLI での作り方も載せています。
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
    （外部のチャット AI で作った案を持ち込んで取り込む使い方にも対応）
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
