import Foundation

@Observable
@MainActor
final class TaskCreateViewModel {
    var title = ""
    var memo = ""
    var hasDueDate = false
    var dueDate = Date()
    var isLoading = false
    var errorMessage: String?

    var isValid: Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private let repository: any TaskRepository

    init(repository: any TaskRepository) {
        self.repository = repository
    }

    func createTask() async throws {
        isLoading = true
        defer { isLoading = false }
        let task = TaskItem(
            title: title.trimmingCharacters(in: .whitespaces),
            memo: memo,
            dueDate: hasDueDate ? dueDate : nil
        )
        try await repository.createTask(task)
    }
}
