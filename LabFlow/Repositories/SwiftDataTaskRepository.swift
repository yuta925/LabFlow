import Foundation
import SwiftData

@MainActor
final class SwiftDataTaskRepository: TaskRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchTasks() async throws -> [TaskItem] {
        let descriptor = FetchDescriptor<TaskItem>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func createTask(_ task: TaskItem) async throws {
        modelContext.insert(task)
        try modelContext.save()
    }

    func updateTask(_ task: TaskItem) async throws {
        task.updatedAt = Date()
        try modelContext.save()
    }

    func deleteTask(_ task: TaskItem) async throws {
        modelContext.delete(task)
        try modelContext.save()
    }
}
