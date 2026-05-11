import SwiftUI

struct MarkdownFormattingToolbar: View {
    let controller: MarkdownEditorController

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 4) {
                FormatButton(label: "見出し", systemImage: "textformat.size.larger") {
                    controller.insertHeading()
                }
                FormatButton(label: "小見出し", systemImage: "textformat.size") {
                    controller.insertSubheading()
                }
                FormatButton(label: "箇条書き", systemImage: "list.bullet") {
                    controller.insertBullet()
                }
                FormatButton(label: "太字", systemImage: "bold") {
                    controller.insertBold()
                }
                FormatButton(label: "斜体", systemImage: "italic") {
                    controller.insertItalic()
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 44)
        .background(.bar)
    }
}

private struct FormatButton: View {
    let label: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: systemImage)
                    .font(.system(size: 16))
                Text(label)
                    .font(.system(size: 10))
            }
            .frame(width: 56, height: 36)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(.primary)
    }
}
