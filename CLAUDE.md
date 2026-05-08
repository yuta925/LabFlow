# CLAUDE.md

## Project Overview

LabFlow iOS は、研究室メンバーが研究タスク・研究ログ・相談事項を整理し、研究に集中しやすい環境を作るための iOS アプリです。

このアプリの目的は、単なるタスク管理ではなく、研究活動における以下の課題を解決することです。

- 次にやることが分からない
- 詰まっていても相談しづらい
- 研究の進捗や課題が属人化する
- 過去の知見が共有されにくい
- 研究ログが残らず、振り返りにくい

LabFlow iOS では、研究タスク・研究ログ・相談チケットを通して、研究の「詰まり」「相談」「次にやること」を見える化します。

---

## Tech Stack

このプロジェクトでは、以下の技術を使用します。

- Swift
- SwiftUI
- Combine
- Swift Concurrency
- SwiftData
- MVVM
- GitHub Projects
- Claude Code / Claude PR Review

---

## Architecture Policy

基本構成は、MVVM + Repository とします。

```text
View
↓
ViewModel
↓
Repository
↓
SwiftData / API
```

### View

View は UI 表示とユーザー操作の受け取りに集中してください。

View に書いてよいもの：

- 画面レイアウト
- ボタンタップ
- フォーム入力
- 画面遷移
- Sheet / Alert の表示制御
- ViewModel のメソッド呼び出し

View に書かないもの：

- SwiftData の直接操作
- API 通信
- 複雑なバリデーション
- データ保存・削除・更新の詳細
- ビジネスロジック

### ViewModel

ViewModel は画面状態とロジックを担当してください。

ViewModel が担当するもの：

- 入力値の管理
- バリデーション
- ローディング状態
- エラー状態
- Repository の呼び出し
- View に表示するデータの整形

### Repository

Repository はデータアクセスを担当してください。

Repository が担当するもの：

- SwiftData からの取得
- SwiftData への保存
- データ更新
- データ削除
- 将来的な API / Supabase 連携

Repository はできるだけ protocol と実装に分けてください。

---

## SwiftUI / Combine / Swift Concurrency Policy

### SwiftUI

SwiftUI は画面構築に使用します。

View が肥大化した場合は、`Components/` に小さな View として分割してください。

### Combine

Combine は、状態の流れを整理したい場面でのみ使用してください。

使ってよい場面：

- 入力値のバリデーション
- 検索キーワードの debounce
- フィルタ条件の監視
- 複数の入力状態を組み合わせたボタン活性制御

避ける場面：

- 単純なボタンタップ
- 単純な保存処理
- `async/await` の方が自然な非同期処理

### Swift Concurrency

Swift Concurrency は、非同期処理に使用してください。

使う場面：

- Repository からのデータ取得
- SwiftData への保存処理
- 将来的な API 通信
- Supabase 連携
- ローディング状態を伴う処理

UI 状態を更新する ViewModel は、原則として `@MainActor` を付けてください。

---

## Directory Structure

基本的なディレクトリ構成は以下を想定します。

```text
LabFlow/
├── App/
│   └── LabFlowApp.swift
│
├── Features/
│   ├── Home/
│   │   ├── Views/
│   │   └── ViewModels/
│   │
│   ├── Tasks/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   │
│   ├── ResearchLogs/
│   │   ├── Views/
│   │   ├── ViewModels/
│   │   └── Components/
│   │
│   └── ConsultationTickets/
│       ├── Views/
│       ├── ViewModels/
│       └── Components/
│
├── Models/
├── Repositories/
├── Shared/
│   ├── Components/
│   ├── Extensions/
│   └── Utilities/
│
└── Resources/
```

既存のディレクトリ構成がある場合は、既存構成を優先してください。

---

## Main Domain Models

MVP では、以下のモデルを中心に実装します。

### TaskItem

研究に関する作業タスクを表します。

主な項目：

- `id`
- `title`
- `memo`
- `status`
- `dueDate`
- `createdAt`
- `updatedAt`

### ResearchLog

日次・週次の研究ログを表します。

主な項目：

- `id`
- `title`
- `did`
- `learned`
- `blocked`
- `nextAction`
- `question`
- `createdAt`
- `updatedAt`

### ConsultationTicket

研究中の詰まりや相談事項を表します。

主な項目：

- `id`
- `title`
- `problem`
- `tried`
- `hypothesis`
- `question`
- `status`
- `createdAt`
- `updatedAt`

---

## GitHub Workflow

開発は Issue / Branch / Pull Request 単位で進めます。

基本フロー：

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

### Issue

1 Issue は 1〜3時間程度で完了できる粒度にしてください。

大きすぎる Issue は、実装前に分割してください。

### Branch

`main` に直接 push しないでください。

ブランチ名は以下の形式にしてください。

```text
feature/{issue番号}-{内容}
fix/{issue番号}-{内容}
refactor/{issue番号}-{内容}
docs/{issue番号}-{内容}
```

例：

```text
feature/12-task-list
fix/24-task-status-save-error
docs/31-update-readme
```

### Commit

コミットメッセージは以下の形式を推奨します。

```text
feat: add task list screen
fix: prevent empty task title
refactor: split task form component
docs: update README
```

---

## Pull Request Policy

Pull Request は小さく保ってください。

原則：

- 1 PR = 1 Issue
- 無関係な変更を混ぜない
- 大規模なリファクタリングを勝手に行わない
- PR の目的と変更内容を明確にする
- Xcode でビルドできる状態にする
- 既存機能を壊さない

PR 作成時は、以下を記載してください。

```md
## 概要

## 関連Issue

close #

## 変更内容

- [ ] 

## 確認したこと

- [ ] Xcodeでビルドできる
- [ ] 画面上で動作確認できる
- [ ] 既存機能を壊していない

## Claudeに重点的にレビューしてほしいこと

- 
```

---

## Claude Skills

作業内容に応じて、以下の Skills を参照してください。

### ios-architecture

使用する場面：

- SwiftUI 実装
- ViewModel 設計
- Repository 設計
- SwiftData 保存処理
- Combine / Swift Concurrency の使い分け
- MVVM の責務分離

参照：

```text
.claude/skills/ios-architecture/SKILL.md
```

### github-workflow

使用する場面：

- Issue 作成
- ブランチ運用
- コミット
- Pull Request 作成
- GitHub Projects の整理

参照：

```text
.claude/skills/github-workflow/SKILL.md
```

### issue-planning

使用する場面：

- 大きな機能を Issue に分解する
- Sprint Planning を行う
- MVP に必要なタスクを整理する
- 完了条件を定義する

参照：

```text
.claude/skills/issue-planning/SKILL.md
```

### pr-review

使用する場面：

- Pull Request レビュー
- セルフレビュー
- マージ前チェック
- Claude にレビューを依頼する

参照：

```text
.claude/skills/pr-review/SKILL.md
```

---

## Claude Usage Rules

Claude は、実装補助・レビュー補助として使用します。

Claude に依頼してよいこと：

- Issue の分解
- 実装方針の提案
- 小さな Issue の実装
- PR レビュー
- バグ調査
- リファクタリング案の提案

Claude に任せすぎないこと：

- アプリ全体の設計判断
- 研究室アプリとして本当に使いやすいかの判断
- 大規模な設計変更
- 無関係なコード整理
- Secret や API Key の管理

Claude が実装する場合も、最終判断は開発者が行います。

---

## Prohibited Actions

以下は禁止します。

- `main` に直接 push する
- 無関係な大規模リファクタリングを行う
- 既存機能の挙動を勝手に変える
- Secret や API Key をコードに直接書く
- 不要な外部ライブラリを追加する
- PR の目的と関係ないファイルを変更する
- View に SwiftData や API 通信を直接書く
- エラーを握りつぶす
- ビルドできない状態で PR を出す

---

## Review Checklist

実装後・PR 作成前に以下を確認してください。

- [ ] Xcode でビルドできる
- [ ] iPhone Simulator で主要機能を確認できる
- [ ] View にロジックが寄りすぎていない
- [ ] ViewModel と Repository の責務が分かれている
- [ ] SwiftData の詳細が View に漏れていない
- [ ] Combine を使いすぎていない
- [ ] Swift Concurrency のエラー処理がある
- [ ] 既存機能を壊していない
- [ ] API Key や Secret が含まれていない
- [ ] PR の目的と関係ない変更が混ざっていない

---

## Development Priority

開発では、以下の順番を優先してください。

1. MVP として動くこと
2. 研究室アプリとして使いやすいこと
3. 責務分離ができていること
4. 将来的に Supabase 連携しやすいこと
5. UI が分かりやすいこと
6. リファクタリングや細かい改善

最初から完璧な設計を目指すより、まずは小さく動くものを作り、Issue / PR 単位で改善してください。
