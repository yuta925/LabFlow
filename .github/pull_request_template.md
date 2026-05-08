## `.github/pull_request_template.md`

```md
## 概要

この PR で何を変更したかを簡潔に書く。

例：

- タスク一覧画面を追加
- TaskItem モデルを追加
- SwiftData でタスクを保存できるようにした

---

## 関連 Issue

close #

---

## 変更内容

- [ ] 
- [ ] 
- [ ] 

---

## 確認したこと

- [ ] Xcode でビルドできる
- [ ] iPhone Simulator で動作確認した
- [ ] 主要画面がクラッシュしない
- [ ] 既存機能を壊していない
- [ ] 必要に応じて SwiftUI Preview で確認した
- [ ] PR の目的と関係ない変更を含めていない

---

## UI 変更

UI に変更がある場合は、スクリーンショットや説明を書く。

| Before | After |
|---|---|
|  |  |

---

## 実装メモ

設計上の判断や、実装時に意識したことを書く。

例：

- View にロジックを書きすぎないように ViewModel に分離した
- 将来的な Supabase 連携を考えて Repository 経由にした
- 単純な保存処理なので Combine ではなく Swift Concurrency を使った

---

## Claude に重点的にレビューしてほしいこと

- [ ] SwiftUI の状態管理が適切か
- [ ] Combine の使い方が複雑になりすぎていないか
- [ ] Swift Concurrency の使い方が適切か
- [ ] MVVM として責務分離できているか
- [ ] View にロジックが寄りすぎていないか
- [ ] Repository にデータアクセスが分離されているか
- [ ] 将来的に Supabase 連携しやすい構成か
- [ ] 既存機能への影響がないか
- [ ] 命名が分かりやすいか

---

## Claude レビュー依頼用コメント

必要であれば、PR 作成後に以下をコメントする。

```text
@claude review once

以下の観点でレビューしてください。

1. SwiftUI の状態管理が適切か
2. Combine の使い方が複雑になりすぎていないか
3. Swift Concurrency の使い方が適切か
4. MVVM として責務分離できているか
5. Repository 層にデータアクセスが分離されているか
6. 将来的に Supabase 連携しやすい構成か
7. View が肥大化していないか
8. バグや例外ケースがないか
9. 既存機能に影響がないか

出力は日本語でお願いします。
重要度を Important / Question / Nit に分けてください。
