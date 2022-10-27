//
//  Card.swift
//  Set
//
//  Created by Andrew Shields on 8/30/22.
//

import SwiftUI

struct Card<CardSymbol>: View where CardSymbol: View {
    
    let card: SetGameModel.Card
    let cardShape: CardSymbol

    var body: some View {
        ZStack {
            cardShape
        }
        .padding(4)
        .aspectCardify(
            card: card,
            padding: .zero)
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        let card = SetGameModel.Card(status: UInt8(64), id: 0)
        Card(card: card, cardShape: game.cardFeatureBuilder(card: card))
    }
}
