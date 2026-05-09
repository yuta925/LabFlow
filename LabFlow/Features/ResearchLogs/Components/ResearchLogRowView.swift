import SwiftUI

struct ResearchLogRowView: View {
    let log: ResearchLog

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(log.title)
                .font(.body)
            Text(log.createdAt, style: .date)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}
