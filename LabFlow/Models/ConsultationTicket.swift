import Foundation
import SwiftData

enum ConsultationTicketStatus: String, Codable, CaseIterable {
    case open = "open"
    case resolved = "resolved"

    var label: String {
        switch self {
        case .open: return "相談中"
        case .resolved: return "解決済み"
        }
    }
}

@Model
final class ConsultationTicket {
    @Attribute(.unique) var id: UUID
    var title: String
    var problem: String
    var tried: String
    var hypothesis: String
    var question: String
    var status: ConsultationTicketStatus
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        problem: String = "",
        tried: String = "",
        hypothesis: String = "",
        question: String = "",
        status: ConsultationTicketStatus = .open
    ) {
        self.id = UUID()
        self.title = title
        self.problem = problem
        self.tried = tried
        self.hypothesis = hypothesis
        self.question = question
        self.status = status
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
