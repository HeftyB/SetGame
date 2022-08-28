//
//  CardGame.swift
//  Set
//
//  Created by Andrew Shields on 8/27/22.
//

import Foundation


struct SetGameModel {
    var deck: Array<Card>
    var cardsOnBoard: Array<Card>
    var indiciesOfSelectedCards: Array<Int>
    
    init() {
        deck = []
        cardsOnBoard = []
        indiciesOfSelectedCards = []
    }
    
    enum CardColor {
        case red, blue, green
    }
    
    enum CardSymbol {
        case squiggle, diamond, oval
    }
    
    enum CardShading {
        case solid, open, striped
    }
    
    enum CardNumber {
        case one, two, three
    }
    
    struct Card {
        let color: CardColor
        let symbol: CardSymbol
        let shading: CardShading
        let number: CardNumber
    }
}
