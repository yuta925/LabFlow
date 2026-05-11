import UIKit

final class MarkdownEditorController {
    weak var textView: UITextView?

    func insertHeading() { insertLinePrefix("## ") }
    func insertSubheading() { insertLinePrefix("### ") }
    func insertBullet() { insertLinePrefix("- ") }
    func insertBold() { wrapSelection(prefix: "**", suffix: "**") }
    func insertItalic() { wrapSelection(prefix: "*", suffix: "*") }

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
    }

    private func wrapSelection(prefix: String, suffix: String) {
        guard let textView else { return }
        guard let selectedRange = textView.selectedTextRange else { return }
        let selectedText = textView.text(in: selectedRange) ?? ""

        if selectedText.isEmpty {
            textView.insertText(prefix + suffix)
            if let pos = textView.position(from: selectedRange.start, offset: prefix.count) {
                textView.selectedTextRange = textView.textRange(from: pos, to: pos)
            }
        } else {
            textView.replace(selectedRange, withText: prefix + selectedText + suffix)
        }
    }
}
