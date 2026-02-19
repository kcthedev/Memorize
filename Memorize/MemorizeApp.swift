//
//  MemorizeApp.swift
//  Memorize
//
//  Created by KC Thomas on 12/13/25.
//

import SwiftUI

@main
struct MemorizeApp: App {
    
    @StateObject private var viewModel = MemorizeEmojiViewModel()

    var body: some Scene {
        WindowGroup {
            EmojiMemorizeGameView(viewModel: viewModel)
        }
    }
}
