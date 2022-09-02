//
//  SetApp.swift
//  Set
//
//  Created by Andrew Shields on 8/26/22.
//

import SwiftUI

@main
struct SetApp: App {
    private let game = SetGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(game: game)
        }
    }
}
