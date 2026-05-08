---
name: github-workflow
description: LabFlow iOS の GitHub Projects, Issue, Branch, Commit, Pull Request の運用時に使用する。
---

# GitHub Workflow Skill

## 目的

この Skill は、LabFlow iOS の GitHub 運用を行うときに使用する。

GitHub を単なるコード置き場ではなく、以下の中心として使う。

- タスク管理
- スプリント管理
- 実装単位の管理
- Pull Request レビュー
- Claude Code との協働

---

## 使用する場面

この Skill は、以下の作業時に使用する。

- GitHub Projects の整理
- Issue の作成
- Issue の粒度調整
- ブランチ作成
- コミットメッセージ作成
- Pull Request 作成
- Pull Request のマージ前確認
- Claude に Issue 実装や PR レビューを依頼する前の整理

---

## GitHub Projects の運用

GitHub Projects では、以下のステータスを使う。

```text
Backlog
Todo
In Progress
Pull Request
Done
```

---

## Status の意味

| Status | 意味 |
|---|---|
| Backlog | いつかやりたいタスク |
| Todo | 今スプリントでやるタスク |
| In Progress | 作業中 |
| Pull Request | PR 作成済み・レビュー待ち |
| Done | 完了 |

---

## 基本フロー

開発は以下の流れで行う。

```text
GitHub Projects でタスク管理
↓
Issue を作成
↓
Issue ごとにブランチを作成
↓
実装
↓
Pull Request を作成
↓
Claude にレビュー依頼
↓
自分で確認
↓
main へマージ
```

---

## Issue の粒度

1つの Issue は、1〜3時間程度で完了できる大きさにする。

悪い例：

```text
タスク管理機能を作る
```

良い例：

```text
タスク一覧画面を作る
タスク作成画面を作る
タスクの状態を変更できるようにする
SwiftDataでタスクを保存する
```

Issue が大きすぎる場合は、実装前に分割する。

---

## Issue テンプレート

Issue には以下を書く。

```md
## 目的

このIssueで実現したいことを書く。

## 背景

なぜこの機能が必要なのかを書く。

## 実装内容

- [ ] 
- [ ] 
- [ ] 

## 完了条件

- [ ] Xcodeでビルドできる
- [ ] 画面上で動作確認できる
- [ ] 既存機能を壊していない
- [ ] 必要に応じてPreviewで確認できる

## 補足

関連する画面、モデル、参考資料などを書く。
```

---

## ブランチ運用

`main` ブランチに直接 push しない。

Issue ごとにブランチを作成する。

```text
main
  ↑
feature/12-task-list
feature/18-research-log-create
fix/24-task-status-not-saved
```

---

## ブランチ命名規則

```text
feature/{issue番号}-{内容}
fix/{issue番号}-{内容}
refactor/{issue番号}-{内容}
docs/{issue番号}-{内容}
```

例：

```text
feature/12-task-list
feature/18-add-research-log
fix/24-task-status-save-error
docs/31-update-readme
```

---

## コミットメッセージ

コミットメッセージは以下の形式にする。

```text
feat: add task list screen
feat: add research log model
fix: prevent empty task title
refactor: split task form component
docs: update README
```

---

## Prefix

| Prefix | 内容 |
|---|---|
| feat | 機能追加 |
| fix | バグ修正 |
| refactor | リファクタリング |
| docs | ドキュメント修正 |
| chore | 設定・雑務 |
| test | テスト追加・修正 |

---

## Pull Request の作成

Pull Request には以下を書く。

```md
## 概要

このPRで何を変更したかを書く。

## 関連Issue

close #

## 変更内容

- [ ] 
- [ ] 
- [ ] 

## 確認したこと

- [ ] Xcodeでビルドできる
- [ ] 画面遷移が正常に動く
- [ ] 既存機能に影響がない
- [ ] SwiftUI Previewで確認した

## Claudeに重点的にレビューしてほしいこと

- SwiftUIの状態管理が適切か
- Combineの使い方が複雑になりすぎていないか
- Swift Concurrencyの使い方が適切か
- MVVMとして責務分離できているか
- Viewにロジックが寄りすぎていないか
- 命名が分かりやすいか
```

---

## Pull Request の原則

- 1 PR で複数の大きな機能を混ぜない
- 1 PR は 1 Issue に対応させる
- 無関係なリファクタリングを混ぜない
- Claude にレビューしてほしい観点を明記する
- PR 作成後は自分でも必ず動作確認する

---

## PR マージ前チェック

PR をマージする前に、以下を確認する。

- [ ] Xcode でビルドできる
- [ ] iPhone Simulator で動作確認した
- [ ] 主要画面がクラッシュしない
- [ ] 既存機能を壊していない
- [ ] Claude のレビューを確認した
- [ ] Claude の指摘を鵜呑みにせず、自分で判断した
- [ ] Issue の完了条件を満たしている
- [ ] 不要な変更が混ざっていない

---

## Claude への依頼方針

Claude に依頼するときは、Issue または PR 単位で依頼する。

悪い例：

```text
@claude アプリを全部作って
```

良い例：

```text
@claude このIssueを実装してください。
SwiftUI + MVVM + SwiftData の構成でお願いします。
既存のディレクトリ構成を確認し、必要最小限の変更でお願いします。
```

---

## GitHub Projects のスプリント運用

1週間を1スプリントとする。

```text
月曜：今週やる Issue を Todo に移動
火曜〜木曜：In Progress で実装
金曜：Pull Request 作成・レビュー・修正
土日：振り返り・次スプリント計画
```

---

## スプリント振り返りテンプレート

```md
## Sprint 振り返り

### 今週やったこと

- 

### できたこと

- 

### できなかったこと

- 

### 詰まったこと

- 

### 次に改善すること

- 

### 来週やること

- 
```

---

## 作業時のチェックリスト

- [ ] Issue の目的が明確である
- [ ] Issue が 1〜3時間程度の粒度である
- [ ] ブランチ名が命名規則に沿っている
- [ ] コミットメッセージが分かりやすい
- [ ] PR に概要・関連 Issue・確認事項が書かれている
- [ ] Claude にレビュー観点を明示している
- [ ] マージ前に自分で動作確認している
