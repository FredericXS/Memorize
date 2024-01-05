//
//  SelectThemeView.swift
//  Memorize
//
//  Created by Frederic 石英 on 05/01/24.
//

import SwiftUI

struct SelectThemeView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    private let maxEmojisToShow = 8

    var body: some View {
        NavigationStack {
            List(viewModel.themes) { theme in
                NavigationLink {
                    EmojiMemoryGameView(viewModel: viewModel, theme: theme)
                } label: {
                    VStack(alignment: .leading) {
                        Text(theme.name)
                            .font(.headline)
                            .foregroundColor(theme.color)
                        
                        HStack {
                            ForEach(theme.content.prefix(maxEmojisToShow), id: \.self) { emoji in
                                Text(emoji)
                                    .font(.title)
                            }
                            
                            if theme.content.count > maxEmojisToShow {
                                Text("...")
                                    .font(.title3)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Memorize!")
        }
    }
}
