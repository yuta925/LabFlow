import Foundation

@Observable
final class TaskListViewModel {
    var tasks: [TaskItem] = []
    var isLoading = false
    var errorMessage: String?

    private let repository: any TaskRepository

    init(repository: any TaskRepository) {
        self.repository = repository
    }

    func loadTasks() async {
        isLoading = true
        defer { isLoading = false }
        do {
            tasks = try await repository.fetchTasks()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
