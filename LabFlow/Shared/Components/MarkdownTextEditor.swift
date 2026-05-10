import SwiftUI
import UIKit

struct MarkdownTextEditor: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String = "内容を入力..."

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = .preferredFont(forTextStyle: .body)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.inputAccessoryView = makeToolbar(coordinator: context.coordinator)
        context.coordinator.textView = textView
        updatePlaceholder(textView)
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text && !context.coordinator.isEditing {
            uiView.text = text
            updatePlaceholder(uiView)
        }
    }

    private func updatePlaceholder(_ textView: UITextView) {
        if text.isEmpty {
            textView.text = placeholder
            textView.textColor = .placeholderText
        } else {
            textView.textColor = .label
        }
    }

    private func makeToolbar(coordinator: Coordinator) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let h2 = UIBarButtonItem(title: "見出し", style: .plain, target: coordinator, action: #selector(Coordinator.insertHeading))
        let h3 = UIBarButtonItem(title: "小見出し", style: .plain, target: coordinator, action: #selector(Coordinator.insertSubheading))
        let bullet = UIBarButtonItem(title: "・", style: .plain, target: coordinator, action: #selector(Coordinator.insertBullet))
        let bold = UIBarButtonItem(title: "B", style: .plain, target: coordinator, action: #selector(Coordinator.insertBold))
        let italic = UIBarButtonItem(title: "I", style: .plain, target: coordinator, action: #selector(Coordinator.insertItalic))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "完了", style: .prominent, target: coordinator, action: #selector(Coordinator.dismissKeyboard))

        bold.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 16)], for: .normal)
        italic.setTitleTextAttributes([.font: UIFont.italicSystemFont(ofSize: 16)], for: .normal)

        toolbar.items = [h2, h3, bullet, bold, italic, spacer, done]
        return toolbar
    }

    final class Coordinator: NSObject, UITextViewDelegate {
        var parent: MarkdownTextEditor
        weak var textView: UITextView?
        var isEditing = false

        init(parent: MarkdownTextEditor) {
            self.parent = parent
        }

        func textViewDidBeginEditing(_ textView: UITextView) {
            isEditing = true
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }

        func textViewDidEndEditing(_ textView: UITextView) {
            isEditing = false
            if textView.text.isEmpty {
                textView.text = parent.placeholder
                textView.textColor = .placeholderText
            }
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        // MARK: - Line prefix insertion

        @objc func insertHeading() {
            insertLinePrefix("## ")
        }

        @objc func insertSubheading() {
            insertLinePrefix("### ")
        }

        @objc func insertBullet() {
            insertLinePrefix("- ")
        }

        private func insertLinePrefix(_ prefix: String) {
            guard let textView else { return }
            let text = textView.text ?? ""
            let selectedRange = textView.selectedRange
            let nsText = text as NSString
            let lineRange = nsText.lineRange(for: selectedRange)
            let lineStart = lineRange.location

            let insertPosition = textView.position(from: textView.beginningOfDocument, offset: lineStart)!
            textView.selectedTextRange = textView.textRange(from: insertPosition, to: insertPosition)
            textView.insertText(prefix)

            parent.text = textView.text
        }

        // MARK: - Inline wrap insertion

        @objc func insertBold() {
            wrapSelection(prefix: "**", suffix: "**")
        }

        @objc func insertItalic() {
            wrapSelection(prefix: "*", suffix: "*")
        }

        private func wrapSelection(prefix: String, suffix: String) {
            guard let textView else { return }
            guard let selectedRange = textView.selectedTextRange else { return }
            let selectedText = textView.text(in: selectedRange) ?? ""

            if selectedText.isEmpty {
                textView.insertText(prefix + suffix)
                // カーソルを prefix の直後に移動
                if let pos = textView.position(from: selectedRange.start, offset: prefix.count) {
                    textView.selectedTextRange = textView.textRange(from: pos, to: pos)
                }
            } else {
                textView.replace(selectedRange, withText: prefix + selectedText + suffix)
            }

            parent.text = textView.text
        }

        @objc func dismissKeyboard() {
            textView?.resignFirstResponder()
        }
    }
}
