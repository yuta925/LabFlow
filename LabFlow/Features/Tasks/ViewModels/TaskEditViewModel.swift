import Foundation

@Observable
@MainActor
final class TaskEditViewModel {
    var title: String
    var memo: String
    var status: TaskStatus
    var hasDueDate: Bool
    var dueDate: Date
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let task: TaskItem
    private let repository: any TaskRepository

    init(task: TaskItem, repository: any TaskRepository) {
        self.task = task
        self.repository = repository
        title = task.title
        memo = task.memo
        status = task.status
        hasDueDate = task.dueDate != nil
        dueDate = task.dueDate ?? Date()
    }

    func save() async throws {
        isLoading = true
        defer { isLoading = false }

        let originalTitle = task.title
        let originalMemo = task.memo
        let originalStatus = task.status
        let originalDueDate = task.dueDate

        task.title = title.trimmingCharacters(in: .whitespaces)
        task.memo = memo
        task.status = status
        task.dueDate = hasDueDate ? dueDate : nil

        do {
            try await repository.updateTask(task)
        } catch {
            task.title = originalTitle
            task.memo = originalMemo
            task.status = originalStatus
            task.dueDate = originalDueDate
            throw error
        }
    }
}
