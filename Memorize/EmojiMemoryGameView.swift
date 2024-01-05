//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by Frederic 石英 on 30/12/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    var theme: EmojiMemoryGame.Theme
    
    private let aspectRatio: CGFloat = 2/3
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1)
    private let dealInterval = 0.125
    private let deckWidth: CGFloat = 50
    
    var body: some View {
        VStack {
            cards.foregroundColor(theme.color)
            HStack {
                score
                Spacer()
                deck.foregroundColor(theme.color)
                Spacer()
                shuffle
            }
            .font(.title2)
        }
        .padding()
        .navigationTitle(theme.name)
        .onAppear { viewModel.newGame(theme) }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Game") {
                    dealt.removeAll()
                    viewModel.newGame(theme)
                }
            }
        }
    }
    
    private var score: some View {
        Text("Score: \(viewModel.score)")
            .animation(nil)
    }
    
    private var shuffle: some View {
        Button("Shuffle") {
            withAnimation {
                viewModel.shuffle()
            }
        }
    }
    
    private var cards: some View {
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio) { card in
            if isDealt(card) {
                view(for: card)
                    .padding(spacing)
                    .overlay(
                        FlyingNumber(
                            number: scoreChange(causedBy: card)
                        )
                    )
                    .zIndex(scoreChange(causedBy: card) != 0 ? 100 : 0)
                    .onTapGesture { choose(card, cards: viewModel.cards) }
            }
        }
    }
    
    private func view(for card: Card) -> some View {
        CardView(card)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            .transition(.asymmetric(insertion: .identity, removal: .identity))
    }
    
    private func choose(_ card: Card, cards: [Card]) {
        withAnimation {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    @State private var lastScoreChange = (0, causedByCardId: "")
    
    private func scoreChange(causedBy card: Card) -> Int {
        let (amount, id) = lastScoreChange
        return card.id == id ? amount : 0
    }
    
    // MARK: - Dealing from a Deck
    
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !isDealt($0) }
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                view(for: card)
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .onTapGesture {
            // All cards start shuffled
            viewModel.shuffle()
            deal()
        }
    }
    
    private func deal() {
        var delay: TimeInterval = 0
        let totalDealDuration = Double(viewModel.cards.count) * dealInterval

        for card in viewModel.cards {
            withAnimation(dealAnimation.delay(delay)) {
                _ = dealt.insert(card.id)
            }
            delay += dealInterval
        }
        
        // Reveal all the cards for some seconds after the animation ends
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDealDuration) {
            withAnimation {
                viewModel.initialReveal()
            }
        }
    }
}
