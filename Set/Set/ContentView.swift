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
        VStack {
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                Card(card: card,
                     cardShape: game.cardFeatureBuilder(card: card))
                    .padding(4)
                    .onTapGesture { game.selectCard(card) }
            })
            .padding(.horizontal)
            
            HStack {
                Group {
                    Button(action: game.newGame) {
                        Text("New Game")
                    }
                    Button(action: game.deal3) {
                        Text("Deal 3")
                    }
                }
                .border(.black, width: 1)
                .padding()
                .background(.brown)
                .frame(width: 300, height: 200)
            }
        }
        .background(.teal)
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
