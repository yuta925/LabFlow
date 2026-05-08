import Foundation

@Observable
@MainActor
final class TaskDetailViewModel {
    var task: TaskItem
    var isLoading = false
    var errorMessage: String?

    private let repository: any TaskRepository

    init(task: TaskItem, repository: any TaskRepository) {
        self.task = task
        self.repository = repository
    }

    func updateStatus(_ status: TaskStatus) async {
        task.status = status
        do {
            try await repository.updateTask(task)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func deleteTask() async throws {
        isLoading = true
        defer { isLoading = false }
        try await repository.deleteTask(task)
    }
}
