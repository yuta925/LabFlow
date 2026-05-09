import Foundation
import SwiftData

@Model
final class ResearchLog {
    @Attribute(.unique) var id: UUID
    var title: String
    var did: String
    var learned: String
    var blocked: String
    var nextAction: String
    var question: String
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        did: String = "",
        learned: String = "",
        blocked: String = "",
        nextAction: String = "",
        question: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.did = did
        self.learned = learned
        self.blocked = blocked
        self.nextAction = nextAction
        self.question = question
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
