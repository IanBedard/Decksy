import Foundation

struct StudyDeck: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var cards: [StudyCard]

    var dueCount: Int {
        cards.filter(\.isDue).count
    }
}

struct StudyCard: Identifiable, Codable, Equatable {
    var id = UUID()
    var front: String
    var back: String
    var intervalDays: Int = 0
    var ease: Double = 2.5
    var dueDate: Date = .now
    var lastReviewed: Date?

    var isDue: Bool {
        dueDate <= .now
    }
}

enum ReviewGrade {
    case again
    case hard
    case good
    case easy
}
