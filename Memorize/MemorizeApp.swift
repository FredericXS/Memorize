//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Frederic 石英 on 30/12/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            SelectThemeView(viewModel: game)
        }
    }
}
