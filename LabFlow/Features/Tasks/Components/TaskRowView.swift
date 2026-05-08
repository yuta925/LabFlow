import SwiftUI

struct TaskRowView: View {
    let task: TaskItem

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.body)
            HStack(spacing: 8) {
                Text(task.status.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                if let dueDate = task.dueDate {
                    Text(dueDate, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, 2)
    }
}
