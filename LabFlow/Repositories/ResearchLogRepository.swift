import Foundation

@MainActor
protocol ResearchLogRepository {
    func fetchLogs() async throws -> [ResearchLog]
    func createLog(_ log: ResearchLog) async throws
    func updateLog(_ log: ResearchLog) async throws
    func deleteLog(_ log: ResearchLog) async throws
}
