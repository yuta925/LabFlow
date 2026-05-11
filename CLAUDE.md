## Project Overview
 
LabFlow iOS は、研究室メンバーが研究タスク・研究ログ・相談事項を整理し、研究に集中しやすい環境を作るための iOS アプリです。
 
---
 
## Tech Stack
 
Swift / SwiftUI / Combine / Swift Concurrency / SwiftData / Swift Testing / MVVM / GitHub Projects / Claude Code
 
---
 
## Prohibited Actions
 
- `main` に直接 push しない
- 無関係なリファクタリングをしない
- 既存機能の挙動を勝手に変えない
- Secret / API Key をコードに書かない
- 不要な外部ライブラリを追加しない
- View に SwiftData や API 通信を直接書かない
- エラーを握りつぶさない
- ビルドできない状態で PR を出さない
- 既存のテストを壊したまま PR を出さない
- テストを安易にスキップ（`.disabled` 等）しない
---
 
## Rules
 
詳細は以下を参照する。
 
- `.claude/rules/architecture.md` — MVVM 設計・ディレクトリ構成・ドメインモデル
- `.claude/rules/swift-policy.md` — SwiftUI / Combine / Concurrency の使い分け
- `.claude/rules/github-workflow.md` — Issue / Branch / Commit / PR
- `.claude/rules/testing-policy.md` — Swift Testing の書き方・対象・モック方針
- `.claude/rules/review-checklist.md` — PR 作成前チェックリスト
- `.claude/rules/claude-usage.md` — Claude への依頼ルール・開発優先度・Skills
