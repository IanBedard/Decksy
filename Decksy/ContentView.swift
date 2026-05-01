import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: CardStore
    @State private var showingNewDeck = false
    @State private var newDeckTitle = ""

    var body: some View {
        TabView {
            NavigationStack {
                List {
                    ForEach(store.decks) { deck in
                        NavigationLink {
                            DeckDetailView(deckID: deck.id)
                        } label: {
                            DeckRow(deck: deck)
                        }
                    }
                    .onDelete(perform: store.deleteDecks)
                }
                .navigationTitle("Decksy")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showingNewDeck = true
                        } label: {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("Add Deck")
                    }
                }
                .sheet(isPresented: $showingNewDeck) {
                    NavigationStack {
                        Form {
                            TextField("Deck name", text: $newDeckTitle)
                        }
                        .navigationTitle("New Deck")
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    newDeckTitle = ""
                                    showingNewDeck = false
                                }
                            }

                            ToolbarItem(placement: .confirmationAction) {
                                Button("Create") {
                                    store.addDeck(title: newDeckTitle)
                                    newDeckTitle = ""
                                    showingNewDeck = false
                                }
                                .disabled(newDeckTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                            }
                        }
                    }
                }
            }
            .tabItem {
                Label("Decks", systemImage: "rectangle.stack")
            }

            NavigationStack {
                DueTodayView()
            }
            .tabItem {
                Label("Today", systemImage: "calendar")
            }
        }
    }
}

private struct DeckRow: View {
    let deck: StudyDeck

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(deck.title)
                .font(.headline)

            HStack(spacing: 12) {
                Label("\(deck.cards.count) cards", systemImage: "square.on.square")
                Label("\(deck.dueCount) due", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }
}

private struct DueTodayView: View {
    @EnvironmentObject private var store: CardStore

    var dueDecks: [StudyDeck] {
        store.decks.filter { $0.dueCount > 0 }
    }

    var body: some View {
        List {
            if dueDecks.isEmpty {
                ContentUnavailableView(
                    "All caught up",
                    systemImage: "checkmark.circle",
                    description: Text("Cards you review will return when they are due again.")
                )
            } else {
                ForEach(dueDecks) { deck in
                    NavigationLink {
                        StudyView(deckID: deck.id)
                    } label: {
                        DeckRow(deck: deck)
                    }
                }
            }
        }
        .navigationTitle("Due Today")
    }
}

#Preview {
    ContentView()
        .environmentObject(CardStore())
}
