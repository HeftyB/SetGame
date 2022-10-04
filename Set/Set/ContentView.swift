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
                    TopBar(score: game.completedSetsCount, startTime: game.startTime, status: game.status)
                        .frame(height: geometry.size.height / 8)
                    Divider()
                    /// Card Board
                    AspectVGrid(items: game.cards, aspectRatio: SetGameViewModel.CardConstants.cardAspectRatio, content: { card in
                        Card(card: card,
                             cardShape: game.cardFeatureBuilder(card: card))
                            .padding(4)
                            .onTapGesture { game.selectCard(card) }
                    })
                    .padding(.horizontal)
                    
                    ButtonBar(game: game)
                        .padding(.horizontal)
                    
                    Divider()
                }
                Divider()
            }
            .background(RadialGradient(colors: [Color("BoardColor"), .black], center: .center, startRadius: min(geometry.size.width, geometry.size.height) * 0.9, endRadius: min(geometry.size.width, geometry.size.height) * 2.3))
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
