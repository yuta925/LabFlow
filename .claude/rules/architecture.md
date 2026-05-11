# Architecture Policy

基本構成は MVVM + Repository。

```
View → ViewModel → Repository → SwiftData / API
```

## View

書いてよいもの：画面レイアウト、ボタンタップ、フォーム入力、画面遷移、Sheet/Alert 制御、ViewModel 呼び出し

書かないもの：SwiftData 直接操作、API 通信、複雑なバリデーション、ビジネスロジック

## ViewModel

担当：入力値管理、バリデーション、ローディング/エラー状態、Repository 呼び出し、表示データの整形

UI 状態を更新する ViewModel は原則 `@MainActor` を付ける。

## Repository

担当：SwiftData からの取得・保存・更新・削除、将来的な API / Supabase 連携

できるだけ protocol と実装に分ける。

## Directory Structure

```
LabFlow/
├── App/
├── Features/
│   ├── Home/Views/ ViewModels/
│   ├── Tasks/Views/ ViewModels/ Components/
│   ├── ResearchLogs/Views/ ViewModels/ Components/
│   └── ConsultationTickets/Views/ ViewModels/ Components/
├── Models/
├── Repositories/
├── Shared/Components/ Extensions/ Utilities/
└── Resources/
```

既存のディレクトリ構成がある場合は既存構成を優先する。

## Domain Models（MVP）

**TaskItem**：id, title, memo, status, dueDate, createdAt, updatedAt

**ResearchLog**：id, title, did, learned, blocked, nextAction, question, createdAt, updatedAt

**ConsultationTicket**：id, title, problem, tried, hypothesis, question, status, createdAt, updatedAt
