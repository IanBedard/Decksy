import Foundation

final class CardStore: ObservableObject {
    @Published var decks: [StudyDeck] = [] {
        didSet { save() }
    }

    private let storageKey = "decksy.decks.v1"

    init() {
        load()
    }

    func addDeck(title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }

        decks.append(StudyDeck(title: trimmedTitle, cards: []))
    }

    func deleteDecks(at offsets: IndexSet) {
        decks.remove(atOffsets: offsets)
    }

    func addCard(to deckID: StudyDeck.ID, front: String, back: String) {
        let trimmedFront = front.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedBack = back.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedFront.isEmpty, !trimmedBack.isEmpty else { return }
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }) else { return }

        decks[deckIndex].cards.append(StudyCard(front: trimmedFront, back: trimmedBack))
    }

    func deleteCards(from deckID: StudyDeck.ID, at offsets: IndexSet) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }) else { return }
        decks[deckIndex].cards.remove(atOffsets: offsets)
    }

    func review(cardID: StudyCard.ID, in deckID: StudyDeck.ID, grade: ReviewGrade) {
        guard let deckIndex = decks.firstIndex(where: { $0.id == deckID }),
              let cardIndex = decks[deckIndex].cards.firstIndex(where: { $0.id == cardID }) else {
            return
        }

        var card = decks[deckIndex].cards[cardIndex]
        let nextInterval: Int

        switch grade {
        case .again:
            card.ease = max(1.3, card.ease - 0.2)
            nextInterval = 0
        case .hard:
            card.ease = max(1.3, card.ease - 0.15)
            nextInterval = max(1, card.intervalDays)
        case .good:
            nextInterval = card.intervalDays == 0 ? 1 : max(2, Int(Double(card.intervalDays) * card.ease))
        case .easy:
            card.ease += 0.15
            nextInterval = card.intervalDays == 0 ? 3 : max(4, Int(Double(card.intervalDays) * (card.ease + 0.5)))
        }

        card.intervalDays = nextInterval
        card.lastReviewed = .now
        card.dueDate = Calendar.current.date(byAdding: .day, value: nextInterval, to: .now) ?? .now
        decks[deckIndex].cards[cardIndex] = card
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else {
            decks = Self.sampleDecks
            return
        }

        do {
            decks = try JSONDecoder().decode([StudyDeck].self, from: data)
        } catch {
            decks = Self.sampleDecks
        }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(decks) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private static let sampleDecks = [
        StudyDeck(
            title: "Swift Basics",
            cards: [
                StudyCard(front: "What keyword creates a constant?", back: "`let` creates a constant value."),
                StudyCard(front: "What does SwiftUI use to describe screens?", back: "Views, composed from structs that conform to `View`."),
                StudyCard(front: "What property wrapper owns reference state in a root view?", back: "`@StateObject` owns an `ObservableObject`.")
            ]
        ),
        StudyDeck(
            title: "Spanish Starter",
            cards: [
                StudyCard(front: "hola", back: "hello"),
                StudyCard(front: "gracias", back: "thank you"),
                StudyCard(front: "buenos dias", back: "good morning")
            ]
        )
    ]
}
