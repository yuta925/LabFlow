---
name: pr-review
description: LabFlow iOS の Pull Request をレビューし、SwiftUI, Combine, Swift Concurrency, SwiftData, MVVM の観点で問題を確認するときに使用する。
---

# PR Review Skill

## 目的

この Skill は、LabFlow iOS の Pull Request をレビューするときに使用する。

レビューでは、単にコードが動くかだけでなく、以下を確認する。

- SwiftUI として自然な実装か
- MVVM として責務分離できているか
- Combine を使いすぎていないか
- Swift Concurrency が適切に使われているか
- SwiftData の詳細が View に漏れていないか
- 将来的な Supabase 連携を妨げないか
- 既存機能を壊していないか
- 研究室アプリとして使いやすいか

---

## 使用する場面

この Skill は、以下の作業時に使用する。

- Pull Request のレビュー
- Claude に `@claude review once` を依頼するとき
- 実装後のセルフレビュー
- マージ前チェック
- リファクタリング方針の確認
- 既存機能への影響確認

---

## レビューの基本方針

- 重要な問題を優先して指摘する
- Nit と Important を分ける
- 無関係な大規模リファクタリングを要求しない
- PR の目的から外れた指摘をしすぎない
- 修正案には理由を添える
- 実装者が次に何をすればよいか分かるように書く
- Claude の指摘であっても、最終判断は開発者が行う

---

## 重要度の分類

レビューコメントは以下の分類を使う。

### Important

マージ前に修正した方がよい問題。

例：

- ビルドエラー
- クラッシュの可能性
- データが保存されない
- 既存機能を壊す変更
- View にデータアクセスが直接書かれている
- 非同期処理で UI 更新が安全でない
- Secret や API Key が含まれている

### Question

設計意図を確認したい問題。

例：

- なぜこの責務を View に置いたのか
- なぜ Combine を使ったのか
- なぜこの Repository 設計にしたのか
- 将来的な Supabase 連携を考慮しているか

### Nit

修正してもよいが、マージを妨げるほどではない指摘。

例：

- 命名の微調整
- コメントの追加
- 小さな UI 表記の改善
- コード整形
- 軽微な重複

---

## レビュー観点

### 1. SwiftUI

確認すること：

- View が肥大化していないか
- View にビジネスロジックが入りすぎていないか
- `@State`, `@StateObject`, `@ObservedObject`, `@Environment` の使い方が自然か
- 画面遷移が分かりやすいか
- 入力フォームが使いやすいか
- 空状態やエラー状態が表示されるか

悪い例：

```swift
Button("保存") {
    let task = TaskItem(title: title)
    modelContext.insert(task)
    try? modelContext.save()
}
```

理由：

- View が SwiftData の保存処理を直接扱っている
- Repository や ViewModel に分離した方がよい

望ましい方向：

```swift
Button("保存") {
    Task {
        await viewModel.createTask()
    }
}
```

---

### 2. MVVM

確認すること：

- View は UI 表示に集中しているか
- ViewModel が画面状態を管理しているか
- Repository がデータアクセスを担当しているか
- ViewModel が View に依存しすぎていないか
- Repository の詳細が View に漏れていないか

チェック項目：

- [ ] View に保存・削除・取得処理が直接書かれていない
- [ ] ViewModel が Repository を通してデータを扱っている
- [ ] ViewModel がローディング・エラー状態を管理している
- [ ] Repository が protocol と実装に分かれている

---

### 3. Combine

確認すること：

- Combine を使う理由があるか
- 単純な処理に Combine を使いすぎていないか
- debounce やバリデーション用途として自然か
- Publisher の流れが読みやすいか
- メモリリークにつながる参照がないか

Combine を使ってよい場面：

- 検索キーワードの debounce
- 入力フォームのバリデーション
- 複数条件の組み合わせ
- フィルタリング状態の監視

Combine を避けた方がよい場面：

- 単純なボタンタップ
- 単純な保存処理
- `async/await` の方が自然な非同期処理

---

### 4. Swift Concurrency

確認すること：

- 非同期処理が `async/await` で自然に書かれているか
- UI 更新が `@MainActor` 上で行われているか
- `Task {}` が乱用されていないか
- エラーが握りつぶされていないか
- ローディング状態が正しく戻るか

良い例：

```swift
@MainActor
func loadTasks() async {
    isLoading = true
    defer { isLoading = false }

    do {
        tasks = try await taskRepository.fetchTasks()
    } catch {
        errorMessage = error.localizedDescription
    }
}
```

確認ポイント：

- `defer` によってローディング状態が戻る
- `do-catch` でエラーを扱っている
- UI 状態の更新が `@MainActor` 上で行われる

---

### 5. SwiftData

確認すること：

- SwiftData の処理が View に直接書かれていないか
- Repository に分離されているか
- モデル設計が MVP に対して過不足ないか
- 保存・更新・削除が正しく行われるか
- アプリ再起動後もデータが残るか

注意すること：

- SwiftData の都合を View に漏らしすぎない
- 将来的な Supabase 連携を考え、Repository 経由で扱う
- モデルの責務を広げすぎない

---

### 6. Repository

確認すること：

- Repository が protocol と実装に分かれているか
- ViewModel が protocol に依存しているか
- SwiftData 実装と将来的な Supabase 実装を差し替えやすいか
- Repository が UI 状態を持っていないか

望ましい例：

```swift
protocol TaskRepository {
    func fetchTasks() async throws -> [TaskItem]
    func createTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(_ task: TaskItem) async throws
}
```

---

### 7. UI / UX

確認すること：

- 研究室アプリとして使いやすいか
- 研究タスク・研究ログ・相談チケットの違いが分かりやすいか
- 入力項目が多すぎないか
- 空状態が分かりやすいか
- エラー時にユーザーが次に何をすればよいか分かるか
- iPhone 画面で見づらくないか

---

### 8. 既存機能への影響

確認すること：

- 既存画面が壊れていないか
- 既存モデルの変更が他機能に影響していないか
- 無関係なファイル変更が混ざっていないか
- 既存の命名規則や構成と矛盾していないか

---

### 9. セキュリティ

確認すること：

- API Key や Secret がコードに直接書かれていないか
- 将来的な Supabase 連携時に Secret を安全に扱える構成か
- 不要なログ出力で個人情報や研究内容が漏れないか

---

## Claude に PR レビューを依頼する例

```text
@claude review once

以下の観点でレビューしてください。

1. SwiftUIの状態管理が適切か
2. Combineの使い方が複雑になりすぎていないか
3. Swift Concurrencyの使い方が適切か
4. MVVMとして責務分離できているか
5. Repository層にデータアクセスが分離されているか
6. 将来的にバックエンド連携しやすい構成か
7. Viewが肥大化していないか
8. バグや例外ケースがないか
9. 既存機能に影響がないか

出力は日本語でお願いします。
重要度を Important / Question / Nit に分けてください。
```

---

## Claude に修正を依頼する例

```text
@claude 指摘された内容のうち、Important に該当するものだけ修正してください。

条件：
- Nit の修正は行わない
- 無関係なリファクタリングは行わない
- 既存機能の挙動を変えない
- 修正したファイルと理由を説明する
```

---

## マージ前セルフチェック

マージ前に以下を確認する。

- [ ] Xcode でビルドできる
- [ ] iPhone Simulator で主要機能を確認した
- [ ] 新規作成・編集・削除が想定通り動く
- [ ] 既存機能を壊していない
- [ ] View にロジックが寄りすぎていない
- [ ] ViewModel と Repository の責務が分かれている
- [ ] SwiftData の詳細が View に漏れていない
- [ ] Combine を使いすぎていない
- [ ] Swift Concurrency のエラー処理がある
- [ ] API Key や Secret が含まれていない
- [ ] PR の目的と関係ない変更が混ざっていない

---

## レビューコメントの書き方

レビューコメントは、以下の形で書く。

```md
**Important**

この処理は View から SwiftData を直接操作しているため、Repository に分離した方がよいです。

理由：
- View の責務が大きくなる
- 将来的に Supabase に切り替えるときに変更範囲が広がる
- テストや差し替えが難しくなる

修正案：
- `TaskRepository` に `createTask` を追加する
- ViewModel から Repository を呼び出す
- View は `viewModel.createTask()` のみ呼ぶ
```
