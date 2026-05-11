# GitHub Workflow

## フロー

GitHub Projects → Issue 作成 → ブランチ作成 → 実装 → PR 作成 → Claude レビュー → 確認 → main マージ

## Issue

1 Issue は 1〜3時間で完了できる粒度。大きすぎる場合は実装前に分割する。

## Branch

`main` に直接 push 禁止。

```
feature/{issue番号}-{内容}
fix/{issue番号}-{内容}
refactor/{issue番号}-{内容}
docs/{issue番号}-{内容}
```

## Commit

```
feat: add task list screen
fix: prevent empty task title
refactor: split task form component
docs: update README
```

## Pull Request

- 1 PR = 1 Issue
- 無関係な変更を混ぜない
- 大規模リファクタリングを勝手に行わない

PR テンプレート：

```md
## 概要
## 関連Issue
close #
## 変更内容
- [ ]
## 確認したこと
- [ ] Xcodeでビルドできる
- [ ] 画面上で動作確認できる
- [ ] 既存機能を壊していない
## Claudeに重点的にレビューしてほしいこと
-
```
