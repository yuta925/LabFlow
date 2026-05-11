import Foundation

@Observable
@MainActor
final class HomeDashboardViewModel {
    var inProgressTasks: [TaskItem] = []
    var recentLogs: [ResearchLog] = []
    var openTickets: [ConsultationTicket] = []
    var isLoading = false

    var isEmpty: Bool {
        inProgressTasks.isEmpty && recentLogs.isEmpty && openTickets.isEmpty
    }

    private let taskRepository: any TaskRepository
    private let logRepository: any ResearchLogRepository
    private let ticketRepository: any ConsultationTicketRepository

    init(
        taskRepository: any TaskRepository,
        logRepository: any ResearchLogRepository,
        ticketRepository: any ConsultationTicketRepository
    ) {
        self.taskRepository = taskRepository
        self.logRepository = logRepository
        self.ticketRepository = ticketRepository
    }

    func load() async {
        isLoading = true
        defer { isLoading = false }

        async let tasks = try? taskRepository.fetchTasks()
        async let logs = try? logRepository.fetchLogs()
        async let tickets = try? ticketRepository.fetchTickets()

        inProgressTasks = ((await tasks) ?? []).filter { $0.status == .inProgress }
        recentLogs = Array(((await logs) ?? []).prefix(3))
        openTickets = ((await tickets) ?? []).filter { $0.status == .open }
    }
}
