import SwiftUI

struct DeckDetailView: View {
    @EnvironmentObject private var store: CardStore
    @State private var showingAddCard = false

    let deckID: StudyDeck.ID

    private var deck: StudyDeck? {
        store.decks.first { $0.id == deckID }
    }

    var body: some View {
        Group {
            if let deck {
                List {
                    Section {
                        NavigationLink {
                            StudyView(deckID: deck.id)
                        } label: {
                            Label("Study \(deck.dueCount) due cards", systemImage: "play.circle.fill")
                        }
                        .disabled(deck.dueCount == 0)
                        .listRowBackground(DecksyTheme.card)
                    }

                    Section("Cards") {
                        if deck.cards.isEmpty {
                            ContentUnavailableView(
                                "No cards yet",
                                systemImage: "rectangle.badge.plus",
                                description: Text("Add a front and back to start studying.")
                            )
                            .foregroundStyle(DecksyTheme.card)
                            .listRowBackground(DecksyTheme.background)
                        } else {
                            ForEach(deck.cards) { card in
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(card.front)
                                        .font(.headline)
                                        .foregroundStyle(DecksyTheme.deepTeal)
                                    Text(card.back)
                                        .foregroundStyle(DecksyTheme.slateGreen)
                                        .lineLimit(2)
                                }
                                .padding(.vertical, 4)
                                .listRowBackground(DecksyTheme.card)
                            }
                            .onDelete { offsets in
                                store.deleteCards(from: deck.id, at: offsets)
                            }
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(DecksyTheme.background)
                .navigationTitle(deck.title)
                .decksyNavigationChrome()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingAddCard = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("Add Card")
                    }
                }
                .sheet(isPresented: $showingAddCard) {
                    AddCardView(deckID: deck.id)
                }
            } else {
                ContentUnavailableView("Deck not found", systemImage: "questionmark.folder")
            }
        }
    }
}

private struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: CardStore
    @State private var front = ""
    @State private var back = ""

    let deckID: StudyDeck.ID

    var canSave: Bool {
        !front.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !back.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Front") {
                    TextEditor(text: $front)
                        .frame(minHeight: 90)
                        .foregroundStyle(DecksyTheme.deepTeal)
                        .scrollContentBackground(.hidden)
                }
                .listRowBackground(DecksyTheme.card)

                Section("Back") {
                    TextEditor(text: $back)
                        .frame(minHeight: 120)
                        .foregroundStyle(DecksyTheme.deepTeal)
                        .scrollContentBackground(.hidden)
                }
                .listRowBackground(DecksyTheme.card)
            }
            .scrollContentBackground(.hidden)
            .background(DecksyTheme.background)
            .navigationTitle("New Card")
            .decksyNavigationChrome()
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        store.addCard(to: deckID, front: front, back: back)
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeckDetailView(deckID: CardStore().decks[0].id)
            .environmentObject(CardStore())
    }
}
