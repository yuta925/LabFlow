# Architecture

## 技術スタック

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

## SwiftUI / Combine / Swift Concurrency の使い分け

### SwiftUI

画面構築に使用します。

主に以下を担当します。

- 画面レイアウト
- フォーム入力
- 一覧表示
- 画面遷移
- ユーザー操作の受け取り

例：

- `TaskListView`
- `TaskCreateView`
- `ResearchLogListView`
- `ConsultationTicketView`

---

### Combine

状態の変化やイベントの流れを扱うために使用します。

主に以下の場面で使います。

- 入力値のバリデーション
- 検索キーワードの監視
- フィルタ条件の変更
- ViewModel 内の状態更新
- 複数の状態を組み合わせた画面表示

例：

- タスク検索
- ステータスによる絞り込み
- フォーム入力の有効・無効判定

---

### Swift Concurrency

非同期処理に使用します。

主に以下の場面で使います。

- データ保存
- データ取得
- 将来的な API 通信
- Supabase などのバックエンド連携
- 重い処理の非同期実行

例：

```swift
func fetchTasks() async throws -> [TaskItem] {
    try await taskRepository.fetchTasks()
}
```

---

## アーキテクチャ

本アプリでは MVVM を採用します。

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

## 各層の責務

### View

画面表示とユーザー操作を担当します。

- UI の表示
- ボタンタップ
- フォーム入力
- ViewModel へのイベント通知

View には、複雑なビジネスロジックを書かないようにします。

---

### ViewModel

画面の状態とロジックを担当します。

- 入力値の管理
- バリデーション
- Repository の呼び出し
- View に表示するデータの整形
- ローディング状態やエラー状態の管理

ViewModel は、View から受け取ったイベントをもとに、画面の状態を更新します。

---

### Repository

データアクセスを担当します。

- SwiftData への保存
- SwiftData からの取得
- 将来的な API 通信
- データ取得元の切り替え

ViewModel が SwiftData や API の詳細を直接知らないようにするため、Repository 層を用意します。

---

## ディレクトリ構成

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

## データモデル方針

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

## 状態管理方針

### View 内で管理してよい状態

View 内では、画面表示に閉じた一時的な状態のみを管理します。

例：

- 入力中のテキスト
- Sheet の表示状態
- Alert の表示状態
- 選択中のタブ
- 一時的なフィルタ条件

### ViewModel で管理する状態

ViewModel では、画面の主要な状態を管理します。

例：

- タスク一覧
- 研究ログ一覧
- 相談チケット一覧
- ローディング状態
- エラー状態
- バリデーション結果

### Repository で管理する処理

Repository では、データ取得・保存・削除などを扱います。

例：

- `fetchTasks()`
- `createTask()`
- `updateTask()`
- `deleteTask()`

---

## Combine の利用方針

Combine は、状態の流れを整理したい場面で使用します。

ただし、無理にすべての状態管理を Combine で書く必要はありません。

使用する場面：

- 検索キーワードの debounce
- 入力フォームのバリデーション
- 複数条件を組み合わせたフィルタリング
- ViewModel 内の状態変化の監視

使用を避ける場面：

- 単純なボタンタップ処理
- 単純なデータ保存処理
- Swift Concurrency の方が自然に書ける非同期処理

---

## Swift Concurrency の利用方針

Swift Concurrency は、非同期処理をシンプルに書くために使用します。

使用する場面：

- Repository からのデータ取得
- SwiftData への保存処理
- 将来的な API 通信
- Supabase 連携
- ローディング状態を伴う処理

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

## Repository 設計方針

Repository は protocol と実装に分けます。

これにより、将来的に SwiftData から Supabase に切り替える場合も、ViewModel 側の変更を少なくできます。

例：

```swift
protocol TaskRepository {
    func fetchTasks() async throws -> [TaskItem]
    func createTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(_ task: TaskItem) async throws
}
```

実装例：

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

将来的な実装例：

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

## 命名規則

### View

画面を表す型には `View` を付けます。

例：

- `TaskListView`
- `TaskCreateView`
- `ResearchLogListView`
- `ConsultationTicketDetailView`

### ViewModel

ViewModel には `ViewModel` を付けます。

例：

- `TaskListViewModel`
- `TaskCreateViewModel`
- `ResearchLogListViewModel`
- `ConsultationTicketDetailViewModel`

### Repository

Repository には `Repository` を付けます。

例：

- `TaskRepository`
- `SwiftDataTaskRepository`
- `ResearchLogRepository`
- `ConsultationTicketRepository`

### Component

再利用可能な UI 部品には、役割が分かる名前を付けます。

例：

- `TaskStatusBadge`
- `EmptyStateView`
- `PrimaryButton`
- `ResearchLogCard`

---

## エラーハンドリング方針

エラーは ViewModel で受け取り、View に表示できる形に整えます。

View では、エラー内容を直接処理しすぎないようにします。

例：

```swift
@Published var errorMessage: String?
```

View 側では、Alert や Text で表示します。

```swift
.alert("エラー", isPresented: $viewModel.isShowingError) {
    Button("OK") {}
} message: {
    Text(viewModel.errorMessage ?? "不明なエラーが発生しました")
}
```

---

## 開発で重視すること

このプロジェクトでは、以下を重視します。

- SwiftUI の View を肥大化させない
- ViewModel に状態管理を集約する
- Repository にデータアクセスを分離する
- Combine と Swift Concurrency を無理に使いすぎない
- まずはローカルで使える MVP を完成させる
- 将来的な Supabase 連携を妨げない構成にする
- 1つの PR で大きすぎる変更をしない
- 既存機能を壊さない
- Claude の提案は参考にしつつ、最終判断は自分で行う

---

## 今後の拡張を見据えた設計

将来的には、以下の機能を追加する可能性があります。

- Supabase 連携
- ユーザー認証
- 研究室メンバー間でのデータ共有
- 相談チケットへのコメント
- 通知機能
- 研究ログの検索
- AI による研究ログ要約

そのため、MVP 段階から以下を意識します。

- データアクセスを Repository に分離する
- ViewModel が API や SwiftData の詳細を直接知らないようにする
- モデルの責務を明確にする
- 画面ごとに Feature ディレクトリを分ける
- 小さな単位で PR を作成する
