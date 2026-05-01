# Decksy

Decksy is a small SwiftUI flashcard app inspired by Anki. It has decks, cards, a due-today view, and a simple spaced-repetition review flow with Again, Hard, Good, and Easy ratings.

## What you need

To run an iOS app, you need:

- A Mac
- Xcode from the Mac App Store
- An iPhone simulator, which Xcode installs for you

You cannot run an iOS app directly on Windows. This folder contains the project files, but Xcode must build and launch them on a Mac.

## How to run it

1. Move or sync this whole folder to a Mac.
2. Open `Decksy.xcodeproj` in Xcode.
3. At the top of Xcode, choose a simulator such as `iPhone 16` or any available iPhone.
4. Press the triangular Run button, or press `Command + R`.
5. Xcode will build the app and open it in the iPhone Simulator.

## If Xcode asks about signing

For the simulator, signing usually works automatically. If you want to run on a real iPhone:

1. Click the blue project icon in Xcode.
2. Select the `Decksy` target.
3. Open the `Signing & Capabilities` tab.
4. Choose your Apple ID team.
5. Change the bundle identifier from `com.example.decksy` to something unique, like `com.yourname.decksy`.

## Project files

- `Decksy/DecksyApp.swift`: app entry point
- `Decksy/ContentView.swift`: tabs, deck list, due-today screen
- `Decksy/DeckDetailView.swift`: deck screen and add-card sheet
- `Decksy/StudyView.swift`: flashcard review screen
- `Decksy/Models.swift`: deck and card data models
- `Decksy/CardStore.swift`: saves decks locally using `UserDefaults`
