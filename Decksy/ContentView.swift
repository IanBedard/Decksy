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
                        .listRowBackground(DecksyTheme.card)
                    }
                    .onDelete(perform: store.deleteDecks)
                }
                .scrollContentBackground(.hidden)
                .background(DecksyTheme.background)
                .navigationTitle("Decksy")
                .decksyNavigationChrome()
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
                                .foregroundStyle(DecksyTheme.deepTeal)
                                .listRowBackground(DecksyTheme.card)
                        }
                        .scrollContentBackground(.hidden)
                        .background(DecksyTheme.background)
                        .navigationTitle("New Deck")
                        .decksyNavigationChrome()
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
        .tint(DecksyTheme.teal)
        .toolbarBackground(DecksyTheme.navy, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}

private struct DeckRow: View {
    let deck: StudyDeck

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(deck.title)
                .font(.headline)
                .foregroundStyle(DecksyTheme.deepTeal)

            HStack(spacing: 12) {
                Label("\(deck.cards.count) cards", systemImage: "square.on.square")
                Label("\(deck.dueCount) due", systemImage: "clock")
            }
            .font(.subheadline)
            .foregroundStyle(DecksyTheme.slateGreen)
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
                .foregroundStyle(DecksyTheme.card)
                .listRowBackground(DecksyTheme.background)
            } else {
                ForEach(dueDecks) { deck in
                    NavigationLink {
                        StudyView(deckID: deck.id)
                    } label: {
                        DeckRow(deck: deck)
                    }
                    .listRowBackground(DecksyTheme.card)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .background(DecksyTheme.background)
        .navigationTitle("Due Today")
        .decksyNavigationChrome()
    }
}

#Preview {
    ContentView()
        .environmentObject(CardStore())
}
