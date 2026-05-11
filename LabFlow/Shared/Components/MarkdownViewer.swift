import SwiftUI

struct MarkdownViewer: View {
    let content: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if content.isEmpty {
                Text("内容なし")
                    .foregroundStyle(.secondary)
                    .italic()
            } else {
                ForEach(Array(lines.enumerated()), id: \.offset) { _, line in
                    lineView(for: line)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var lines: [String] {
        content.components(separatedBy: "\n")
    }

    @ViewBuilder
    private func lineView(for line: String) -> some View {
        if line.hasPrefix("## ") {
            Text(line.dropFirst(3))
                .font(.title2)
                .bold()
                .padding(.top, 8)
        } else if line.hasPrefix("### ") {
            Text(line.dropFirst(4))
                .font(.headline)
                .padding(.top, 4)
        } else if line.hasPrefix("- ") {
            HStack(alignment: .top, spacing: 6) {
                Text("•")
                    .font(.body)
                Text(inlineFormatted(String(line.dropFirst(2))))
                    .font(.body)
            }
        } else if line.isEmpty {
            Spacer().frame(height: 6)
        } else {
            Text(inlineFormatted(line))
                .font(.body)
        }
    }

    private func inlineFormatted(_ text: String) -> AttributedString {
        let markdown = text
            .replacingOccurrences(of: "\\*\\*(.+?)\\*\\*", with: "**$1**", options: .regularExpression)
            .replacingOccurrences(of: "\\*(.+?)\\*", with: "*$1*", options: .regularExpression)
        return (try? AttributedString(markdown: markdown)) ?? AttributedString(text)
    }
}
