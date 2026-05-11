import Foundation
import SwiftData

@Model
final class ResearchLog {
    @Attribute(.unique) var id: UUID
    var title: String
    var content: String
    var createdAt: Date
    var updatedAt: Date

    init(
        title: String,
        content: String = ""
    ) {
        self.id = UUID()
        self.title = title
        self.content = content
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
