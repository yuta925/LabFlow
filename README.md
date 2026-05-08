# LabFlow iOS

研究室メンバーが、研究タスク・研究ログ・相談事項を共有し、研究に集中しやすい環境を作るための iOS アプリです。


## Why

研究室では、学生の生産性が個人の努力だけでなく、相談しやすさ・進捗の見える化・知識共有の仕組みによって左右されます。

LabFlow iOS は、研究活動における「詰まり」「相談」「次にやること」を見える化し、研究室全体の生産性を高めることを目的とします。

---

## Main Features
- タスク管理
- 研究ログ管理
- 相談チケット管理
- ホーム画面による研究状況の可視化
- 将来的な研究室メンバー間での共有機能

---

## Documentation


| Document | Description |
|---|---|
| [Concept](docs/concept.md) | アプリの目的・解決したい課題・主な機能 |
| [Architecture](docs/architecture.md) | 技術スタック・SwiftUI / Combine / Swift Concurrency の使い分け・設計方針 |

---

## Tech Stack

| 項目 | 技術 |
|---|---|
| Language | Swift |
| UI | SwiftUI |
| 状態管理 | SwiftUI State / Observable / Combine |
| 非同期処理 | Swift Concurrency |
| ローカル保存 | SwiftData |
| アーキテクチャ | MVVM |
| バージョン管理 | Git / GitHub |
| タスク管理 | GitHub Projects |
| AI開発支援 | Claude Code / Claude PR Review |

---

## 開発体制

このプロジェクトでは、Claude Skills を使って開発ルール・設計方針・PRレビュー観点を管理します。

主な Skills:

- `ios-architecture`
- `github-workflow`
- `issue-planning`
- `pr-review`
