import SwiftUI
import UIKit

struct MarkdownTextEditor: UIViewRepresentable {
    @Binding var text: String
    var controller: MarkdownEditorController? = nil
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
        context.coordinator.textView = textView
        controller?.textView = textView
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
    }
}
