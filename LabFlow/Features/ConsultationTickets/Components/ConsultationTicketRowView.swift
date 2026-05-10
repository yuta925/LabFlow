import SwiftUI

struct ConsultationTicketRowView: View {
    let ticket: ConsultationTicket

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(ticket.title)
                .font(.body)
            HStack {
                Text(ticket.status.label)
                    .font(.caption)
                    .foregroundStyle(ticket.status == .open ? .orange : .secondary)
                Spacer()
                Text(ticket.createdAt, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}
