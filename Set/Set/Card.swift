//
//  Card.swift
//  Set
//
//  Created by Andrew Shields on 8/30/22.
//

import SwiftUI

struct Card: View {
    
    let card: SetGameModel.Card
    
    let shape = RoundedRectangle(cornerRadius: 20)
//        .fill().foregroundColor(.white)
    
    var body: some View {
        ZStack {
            shape
            shape.fill().foregroundColor(card.isSelected ? .yellow : .gray)
            VStack {
                Text(card.color.rawValue)
                Text(card.symbol.rawValue)
                Text(card.shading.rawValue)
                Text(card.number.rawValue)
//                Text(card.isSelected ? "YES" : "NO")
            }
        }
        .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
        
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(card: SetGameModel.Card(
            color: SetGameModel.CardColor.green,
            symbol: SetGameModel.CardSymbol.oval,
            shading: SetGameModel.CardShading.striped,
            number: SetGameModel.CardNumber.two,
            id: "1"))
    }
}
