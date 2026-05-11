# Swift Policy

## SwiftUI

View が肥大化したら `Components/` に分割する。

## Combine

使ってよい場面：入力バリデーション、検索 debounce、フィルタ条件監視、複数入力を組み合わせたボタン活性制御

避ける場面：単純なボタンタップ、単純な保存処理、`async/await` の方が自然な非同期処理

## Swift Concurrency

使う場面：Repository からのデータ取得、SwiftData 保存、API 通信、Supabase 連携、ローディング状態を伴う処理
