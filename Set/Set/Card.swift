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
    
//    let feature1: Color
//    let feature2: CardShape
//    let feature3: CardShading
//    let feature4:

    func featureBuilder(card: SetGameModel.Card) {
        
    }
    var body: some View {
        ZStack {
            shape
            shape.fill().foregroundColor(card.isSelected ? .yellow : .gray)
            VStack {
                Text(card.feature1.rawValue)
                Text(card.feature2.rawValue)
                Text(card.feature3.rawValue)
                Text(card.feature4.rawValue)
            }
        }
        .border(/*@START_MENU_TOKEN@*/Color.blue/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/)
        
    }
}

struct CardFeatures {
    
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Card(card: SetGameModel.Card(feature1: .positive, feature2: .positive, feature3: .positive, feature4: .positive, id: 1))
    }
}
