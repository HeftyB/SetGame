//
//  Card.swift
//  Set
//
//  Created by Andrew Shields on 8/30/22.
//

import SwiftUI

struct Card<CardSymbol>: View where CardSymbol: View {
    
    let card: SetGameModel.Card
    let cardBack = RoundedRectangle(cornerRadius: 12)
    let cardShape: CardSymbol

    var body: some View {
        ZStack {
            cardBack
            cardBack.fill().foregroundColor(card.isSelected ? .yellow : .white)
            
            cardShape
        }
        .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: 2)
        .background(.white)
    }
}

struct CardFeatures {
    
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        let card = SetGameModel.Card(feature1: .positive, feature2: .positive, feature3: .nuetral, feature4: .negative, id: 1)
        Card(card: card, cardShape: game.cardFeatureBuilder(card: card))
    }
}
