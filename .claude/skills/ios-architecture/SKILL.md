---
name: ios-architecture
description: SwiftUI, Combine, Swift Concurrency, SwiftData, MVVM を用いた LabFlow iOS の実装・設計・リファクタリング時に使用する。
---

# iOS Architecture Skill

## 目的

この Skill は、LabFlow iOS の設計・実装・リファクタリングを行うときに使用する。

LabFlow iOS は、研究室メンバーが研究タスク・研究ログ・相談事項を整理し、研究に集中しやすい環境を作るための iOS アプリである。

実装時は、SwiftUI / Combine / Swift Concurrency / SwiftData / MVVM を前提とする。

---

## 使用する場面

この Skill は、以下の作業時に使用する。

- SwiftUI の画面実装
- ViewModel の設計
- Repository の設計
- SwiftData を使った保存処理
- Combine を使った入力監視・バリデーション
- Swift Concurrency を使った非同期処理
- MVVM の責務分離レビュー
- 将来的な Supabase 連携を見据えた設計判断

---

## 基本方針

- View は UI 表示とユーザー操作の受け取りに集中する
- ViewModel は画面状態・入力値・バリデーション・Repository 呼び出しを担当する
- Repository はデータ取得・保存・更新・削除を担当する
- View が SwiftData や API の詳細を直接扱わないようにする
- 1つの View が大きくなりすぎたら Component に分割する
- まずは SwiftData によるローカル保存で MVP を完成させる
- 将来的な Supabase 連携を妨げない構成にする
- Combine と Swift Concurrency を無理に使いすぎない

---

## アーキテクチャ

基本構成は MVVM + Repository とする。

```text
View
↓
ViewModel
↓
Repository
↓
SwiftData / API
```

---

## View の責務

View は以下を担当する。

- UI の表示
- 画面レイアウト
- ボタンタップなどのユーザー操作
- フォーム入力
- ViewModel へのイベント通知
- 画面遷移

View に書いてよいもの：

- `@State` による一時的な UI 状態
- Sheet / Alert / Navigation の表示制御
- 入力中のテキスト
- 選択中のタブ
- ViewModel のメソッド呼び出し

View に書かないもの：

- データ保存処理
- SwiftData の直接操作
- API 通信
- 複雑なバリデーション
- ビジネスロジック
- 複雑なフィルタリング処理

---

## ViewModel の責務

ViewModel は以下を担当する。

- 画面状態の管理
- 入力値の管理
- バリデーション
- Repository の呼び出し
- ローディング状態の管理
- エラー状態の管理
- View に表示しやすい形へのデータ整形

例：

```swift
@MainActor
final class TaskListViewModel: ObservableObject {
    @Published private(set) var tasks: [TaskItem] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let taskRepository: TaskRepository

    init(taskRepository: TaskRepository) {
        self.taskRepository = taskRepository
    }

    func loadTasks() async {
        isLoading = true
        defer { isLoading = false }

        do {
            tasks = try await taskRepository.fetchTasks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
```

---

## Repository の責務

Repository は以下を担当する。

- SwiftData からの取得
- SwiftData への保存
- データ更新
- データ削除
- 将来的な API 通信
- データ取得元の切り替え

Repository は protocol と実装に分ける。

```swift
protocol TaskRepository {
    func fetchTasks() async throws -> [TaskItem]
    func createTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(_ task: TaskItem) async throws
}
```

SwiftData 用の実装例：

```swift
final class SwiftDataTaskRepository: TaskRepository {
    func fetchTasks() async throws -> [TaskItem] {
        // SwiftData から取得する
        []
    }

    func createTask(_ task: TaskItem) async throws {
        // SwiftData に保存する
    }

    func updateTask(_ task: TaskItem) async throws {
        // SwiftData のデータを更新する
    }

    func deleteTask(_ task: TaskItem) async throws {
        // SwiftData から削除する
    }
}
```

将来的な Supabase 用の実装例：

```swift
final class SupabaseTaskRepository: TaskRepository {
    func fetchTasks() async throws -> [TaskItem] {
        // Supabase から取得する
        []
    }

    func createTask(_ task: TaskItem) async throws {
        // Supabase に保存する
    }

    func updateTask(_ task: TaskItem) async throws {
        // Supabase のデータを更新する
    }

    func deleteTask(_ task: TaskItem) async throws {
        // Supabase から削除する
    }
}
```

---

## SwiftUI の利用方針

SwiftUI は画面構築に使用する。

主に以下を担当する。

- 画面レイアウト
- 一覧表示
- フォーム入力
- 画面遷移
- ユーザー操作の受け取り

画面例：

- `HomeView`
- `TaskListView`
- `TaskCreateView`
- `ResearchLogListView`
- `ResearchLogCreateView`
- `ConsultationTicketListView`
- `ConsultationTicketCreateView`

---

## Combine の利用方針

Combine は、状態の流れを整理したい場面で使用する。

使用する場面：

- 入力値のバリデーション
- 検索キーワードの debounce
- ステータスによる絞り込み
- 複数の入力状態を組み合わせたボタン活性制御
- ViewModel 内の状態変化の監視

使用を避ける場面：

- 単純なボタンタップ処理
- 単純なデータ保存処理
- Swift Concurrency の方が自然な非同期処理
- Combine を使うことでかえって読みづらくなる処理

---

## Swift Concurrency の利用方針

Swift Concurrency は、非同期処理に使用する。

使用する場面：

- Repository からのデータ取得
- SwiftData への保存
- 将来的な API 通信
- Supabase 連携
- ローディング状態を伴う処理

基本的に ViewModel の公開メソッドは `async` で扱い、UI 更新は `@MainActor` 上で行う。

---

## ディレクトリ構成

基本構成は以下とする。

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
│   ├── TaskItem.swift
│   ├── ResearchLog.swift
│   └── ConsultationTicket.swift
│
├── Repositories/
│   ├── TaskRepository.swift
│   ├── ResearchLogRepository.swift
│   └── ConsultationTicketRepository.swift
│
├── Shared/
│   ├── Components/
│   ├── Extensions/
│   └── Utilities/
│
└── Resources/
```

---

## 命名規則

### View

画面を表す型には `View` を付ける。

例：

- `TaskListView`
- `TaskCreateView`
- `ResearchLogListView`
- `ConsultationTicketDetailView`

### ViewModel

ViewModel には `ViewModel` を付ける。

例：

- `TaskListViewModel`
- `TaskCreateViewModel`
- `ResearchLogListViewModel`
- `ConsultationTicketDetailViewModel`

### Repository

Repository には `Repository` を付ける。

例：

- `TaskRepository`
- `SwiftDataTaskRepository`
- `ResearchLogRepository`
- `ConsultationTicketRepository`

### Component

再利用可能な UI 部品には、役割が分かる名前を付ける。

例：

- `TaskStatusBadge`
- `EmptyStateView`
- `PrimaryButton`
- `ResearchLogCard`

---

## エラーハンドリング方針

- エラーは ViewModel で受け取る
- View に表示できる文字列へ変換する
- View 側では Alert や Text で表示する
- Repository のエラー詳細を View に漏らしすぎない

例：

```swift
@Published var errorMessage: String?
```

---

## 実装時のチェックリスト

実装後は以下を確認する。

- [ ] View にロジックが寄りすぎていない
- [ ] ViewModel が画面状態を管理している
- [ ] Repository にデータアクセスが分離されている
- [ ] SwiftData の詳細が View に漏れていない
- [ ] Combine を使いすぎていない
- [ ] Swift Concurrency が自然に使われている
- [ ] 命名が分かりやすい
- [ ] 将来的な Supabase 連携を妨げない
- [ ] Xcode でビルドできる
- [ ] iPhone Simulator で動作確認できる
