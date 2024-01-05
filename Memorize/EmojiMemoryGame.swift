//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Frederic 石英 on 31/12/23.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    typealias Card = MemoryGame<String>.Card
        
    struct Theme: Identifiable {
        var name: String
        var color: Color
        var content: [String]
        let id = UUID()
    }
    
    let themes: [Theme] = [
        Theme(name: "Halloween", color: .orange, content: ["👻", "🎃", "🕷️", "😈", "💀", "🕸️", "🧙", "🙀", "👹", "😱", "☠️", "🍭"]),
        Theme(name: "Vehicles", color: .red, content: ["🚗", "🚙", "🚑", "🚚", "🚜", "🚓", "✈️", "🚲", "🛵", "🚂", "🏍️", "🚢", "🛳️", "🛻", "🚁"]),
        Theme(name: "Sports", color: .purple, content: ["⚽️", "🏀", "🏐", "🥊", "⚾️", "🏈", "🥋", "🎾", "🏑", "🏓", "🎿", "🏸", "🤺", "🏄‍♂️"]),
        Theme(name: "Animals", color: .blue, content: ["🐶", "🐒", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐔", "🦆", "🐴", "🦅", "🐂", "🐄", "🐝", "🐸", "🐯", "🦁", "🐷", "🐺", "🐬", "🦒", "🐘", "🦘", "🐊", "🦈"]),
        Theme(name: "Fruits", color: .green, content: ["🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🥭", "🍍", "🫐"])
    ]
    
    private static func createMemoryGame(_ theme: Theme) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: theme.content.count) { pairIndex in
            if theme.content.indices.contains(pairIndex) {
                return theme.content[pairIndex]
            }
            
            return "⁉️"
        }
    }
        
    @Published private var model = createMemoryGame(Theme(name: "Default", color: .blue, content: ["a", "b"])) // Default theme
    
    var cards: [Card] {
        model.cards
    }
    
    var score: Int {
        model.score
    }
    
    var allCardsMatched: Bool {
        model.cards.allSatisfy { $0.isMatched }
    }
            
    // MARK: - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func choose(_ card: Card) {
        model.choose(card)
    }

    func initialReveal() {
        model.cardsFaceUpToggle()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                self.model.cardsFaceUpToggle()
                self.model.startCards()
            }
        }
    }
    
    func newGame(_ theme: Theme) {
        model = EmojiMemoryGame.createMemoryGame(theme)
    }
}
