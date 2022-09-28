//
//  ContentView.swift
//  Set
//
//  Created by Andrew Shields on 8/26/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var game: SetGameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Divider()
                VStack {
                    Divider()
                    TopBar(game: game)
                        .frame(height: geometry.size.height / 8)
                    Divider()
                    /// Card Board
                    AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                        Card(card: card,
                             cardShape: game.cardFeatureBuilder(card: card))
                            .padding(4)
                            .onTapGesture { game.selectCard(card) }
                    })
                    .padding(.horizontal)
                    
                    ButtonBar(game: game)
                    
                    Divider()
                }
                Divider()
            }
            .background(Color("BoardColor"))
        }
        
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
