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
            HStack {
                Button(action: { print("button 1") }) {
                    Text("Button")
                }
                
                Button(action: game.deal3) {
                    Text("Deal 3")
                }
            }
            .padding()
            
            AspectVGrid(items: game.cards, aspectRatio: 2/3, content: { card in
                Card(card: card)
                    .padding(4)
                    .onTapGesture { game.selectCard(card) }
            })
            .padding(.horizontal)
        }
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
