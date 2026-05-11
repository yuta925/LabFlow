# Testing Policy

テストフレームワークは **Swift Testing** を使用する。`XCTest` は新規追加しない（既存テストがある場合のみ維持）。

## 基本方針

- MVP の動作を優先し、テストで開発を止めない
- 価値の高い層から書く：**ViewModel → Repository → Utilities**
- View（SwiftUI）の見た目は基本的にテスト対象外
- カバレッジを目的化しない。壊れたら困るロジックを優先する

---

## テスト対象

### 書く

- **ViewModel**：入力バリデーション、状態遷移（loading / error / success）、Repository 呼び出しの結果整形
- **Repository**：CRUD の挙動、検索・フィルタ条件、エラーパス
- **Utilities / Extensions**：日付整形、文字列処理など純粋ロジック
- **ドメインモデル**：イニシャライザ、計算プロパティ、状態判定

### 書かない（MVP 段階では優先度を下げる）

- SwiftUI の View レイアウト
- 単純な getter / setter
- Apple フレームワーク自体の挙動
- UI スナップショット（必要になってから検討）

---

## Directory Structure

```
LabFlowTests/
├── Features/
│   ├── Tasks/
│   │   └── TaskListViewModelTests.swift
│   ├── ResearchLogs/
│   └── ConsultationTickets/
├── Repositories/
│   └── TaskRepositoryTests.swift
├── Models/
└── Shared/
    ├── Mocks/        // MockRepository など
    └── Helpers/
```

本体のディレクトリ構成にミラーする。既存構成がある場合は既存を優先する。

---

## Naming

- ファイル名：`{対象クラス}Tests.swift`
- `@Suite` 名：対象クラス名（日本語または英語）
- `@Test` 名：「〜の場合、〜になる」が分かる文。日本語可

```swift
@Suite("TaskListViewModel")
struct TaskListViewModelTests {
    @Test("タイトルが空のとき、保存ボタンは無効")
    func disableSaveWhenTitleEmpty() async throws { ... }
}
```

---

## Swift Testing の使い方

### 基本

```swift
import Testing
@testable import LabFlow

@Suite("TaskRepository")
struct TaskRepositoryTests {
    @Test
    func 新規タスクを保存できる() async throws {
        let sut = makeSUT()
        try await sut.create(.init(title: "実験準備"))
        #expect(try await sut.fetchAll().count == 1)
    }
}
```

### 期待値の書き方

- 真偽・等価チェック：`#expect(...)`
- 失敗で以降を止めたいとき：`#require(...)`
- エラー送出の検証：`#expect(throws: SomeError.self) { ... }`

### Parameterized Tests

データバリエーションは `arguments:` を使う。

```swift
@Test(arguments: ["", "  ", "\n"])
func 空白文字のタイトルは無効(_ title: String) {
    #expect(TaskItem.isValidTitle(title) == false)
}
```

### Async / @MainActor

- ViewModel テストは `@MainActor` を付ける
- 非同期は `async throws` をそのまま使い、`await` で待つ

```swift
@MainActor
@Suite("TaskListViewModel")
struct TaskListViewModelTests {
    @Test
    func ロード成功後に items が更新される() async throws {
        let sut = TaskListViewModel(repository: MockTaskRepository(stub: [.sample]))
        await sut.load()
        #expect(sut.items.count == 1)
    }
}
```

---

## Mock / Fake

- Repository は **protocol を切って Mock を差し込む**
- Mock は `LabFlowTests/Shared/Mocks/` に置く
- 1 テスト 1 関心。Mock に過剰な分岐を持たせない

```swift
final class MockTaskRepository: TaskRepositoryProtocol {
    var stub: [TaskItem] = []
    var createCalled = false
    func fetchAll() async throws -> [TaskItem] { stub }
    func create(_ item: TaskItem) async throws {
        createCalled = true
        stub.append(item)
    }
}
```

---

## SwiftData のテスト

- インメモリ `ModelContainer` を使い、本番 DB に触れない
- テストごとに `ModelContainer` を作り直し、状態を分離する

```swift
func makeInMemoryContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try ModelContainer(for: TaskItem.self, configurations: config)
}
```

---

## やってはいけないこと

- View に直接アクセスしてテストする（ViewModel 経由でテスト）
- 本番 SwiftData / API に触れる
- `Thread.sleep` などで待機する（`async/await` を使う）
- グローバル状態に依存する
- テスト同士で順序依存を作る
- 失敗時のメッセージを潰す（`#expect` の表現で意図を明示する）

---

## レビュー観点

- 新規 ViewModel / Repository には最低 1 ケースのテストがあるか
- 失敗パス（エラー・空・境界値）のテストがあるか
- Mock が本物のロジックを持っていないか
- `@MainActor` / `async` の扱いが正しいか
