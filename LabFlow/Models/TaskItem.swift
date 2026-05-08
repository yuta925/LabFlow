import Foundation
import SwiftData

enum TaskStatus: String, Codable, CaseIterable {
    case todo = "todo"
    case inProgress = "inProgress"
    case done = "done"

    var label: String {
        switch self {
        case .todo: return "未着手"
        case .inProgress: return "進行中"
        case .done: return "完了"
        }
    }
}

@Model
final class TaskItem {
    @Attribute(.unique) var id: UUID
    var title: String
    var memo: String
    var status: TaskStatus
    var dueDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        memo: String = "",
        status: TaskStatus = .todo,
        dueDate: Date? = nil
    ) {
        self.id = UUID()
        self.title = title
        self.memo = memo
        self.status = status
        self.dueDate = dueDate
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
