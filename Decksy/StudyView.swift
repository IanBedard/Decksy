import SwiftUI

struct StudyView: View {
    @EnvironmentObject private var store: CardStore
    @State private var currentIndex = 0
    @State private var showingAnswer = false

    let deckID: StudyDeck.ID

    private var deck: StudyDeck? {
        store.decks.first { $0.id == deckID }
    }

    private var dueCards: [StudyCard] {
        deck?.cards.filter(\.isDue) ?? []
    }

    private var currentCard: StudyCard? {
        guard dueCards.indices.contains(currentIndex) else { return dueCards.first }
        return dueCards[currentIndex]
    }

    var body: some View {
        VStack(spacing: 20) {
            if let deck, let card = currentCard {
                Text("\(min(currentIndex + 1, dueCards.count)) of \(dueCards.count)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 18) {
                    Text(showingAnswer ? card.back : card.front)
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, minHeight: 220)
                        .padding()
                        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16))

                    if showingAnswer {
                        ReviewButtons { grade in
                            store.review(cardID: card.id, in: deck.id, grade: grade)
                            showingAnswer = false
                            currentIndex = min(currentIndex, max(dueCards.count - 1, 0))
                        }
                    } else {
                        Button {
                            showingAnswer = true
                        } label: {
                            Label("Show Answer", systemImage: "eye")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }

                Spacer()
            } else {
                ContentUnavailableView(
                    "Study complete",
                    systemImage: "sparkles",
                    description: Text("Nice work. Come back when more cards are due.")
                )
            }
        }
        .padding()
        .navigationTitle(deck?.title ?? "Study")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ReviewButtons: View {
    let onGrade: (ReviewGrade) -> Void

    var body: some View {
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                gradeButton("Again", systemImage: "arrow.counterclockwise", tint: .red, grade: .again)
                gradeButton("Hard", systemImage: "tortoise", tint: .orange, grade: .hard)
            }

            GridRow {
                gradeButton("Good", systemImage: "hand.thumbsup", tint: .green, grade: .good)
                gradeButton("Easy", systemImage: "bolt", tint: .blue, grade: .easy)
            }
        }
    }

    private func gradeButton(_ title: String, systemImage: String, tint: Color, grade: ReviewGrade) -> some View {
        Button {
            onGrade(grade)
        } label: {
            Label(title, systemImage: systemImage)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(tint)
        .controlSize(.large)
    }
}

#Preview {
    NavigationStack {
        StudyView(deckID: CardStore().decks[0].id)
            .environmentObject(CardStore())
    }
}
