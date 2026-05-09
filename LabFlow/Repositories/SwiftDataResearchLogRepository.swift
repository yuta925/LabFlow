import Foundation
import SwiftData

@MainActor
final class SwiftDataResearchLogRepository: ResearchLogRepository {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchLogs() async throws -> [ResearchLog] {
        let descriptor = FetchDescriptor<ResearchLog>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try modelContext.fetch(descriptor)
    }

    func createLog(_ log: ResearchLog) async throws {
        modelContext.insert(log)
        try modelContext.save()
    }

    func updateLog(_ log: ResearchLog) async throws {
        log.updatedAt = Date()
        try modelContext.save()
    }

    func deleteLog(_ log: ResearchLog) async throws {
        modelContext.delete(log)
        try modelContext.save()
    }
}
