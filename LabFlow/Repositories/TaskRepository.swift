import Foundation

protocol TaskRepository {
    func fetchTasks() async throws -> [TaskItem]
    func createTask(_ task: TaskItem) async throws
    func updateTask(_ task: TaskItem) async throws
    func deleteTask(_ task: TaskItem) async throws
}
