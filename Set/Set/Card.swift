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
                .fill()
                .foregroundColor({
                    if card.isHighlighted { return Color("CardHighlightColor") }
                    else if card.isSelected { return Color("CardSelectionColor") }
                    else { return Color.accentColor }
                }())
            
            cardShape
        }
        .border(Color("InnerCardBorderColor"), width: 1)
        .padding(4)
        .background(Color("OuterCardBorderColor"))
        .border(.black)
        .cornerRadius(7.5)
    }
}

struct CardFeatures {
    
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        let game = SetGameViewModel()
        let card = SetGameModel.Card(feature1: .positive, feature2: .positive, feature3: .nuetral, feature4: .positive, id: 1)
        Card(card: card, cardShape: game.cardFeatureBuilder(card: card))
    }
}
