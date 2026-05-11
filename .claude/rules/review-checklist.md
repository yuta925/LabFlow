# Review Checklist

実装後・PR 作成前に確認する。

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
- [ ] Swift Testing でテストを追加・更新した（ViewModel / Repository / 純粋ロジック）
- [ ] 失敗パス（エラー・空・境界値）のテストがある
- [ ] テストがすべて通る（Xcode / `swift test`）
- [ ] Mock は `LabFlowTests/Shared/Mocks/` 配下にあり、本物のロジックを持たせていない
