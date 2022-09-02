//
//  CardGame.swift
//  Set
//
//  Created by Andrew Shields on 8/27/22.
//

import Foundation


struct SetGameModel {
    var deck: [Card]
    var cardsOnBoard: [Card]
    var completedSets: [[Card]]
    var indiciesOfSelectedCards: [Int]
    
    init() {
        deck = []
        cardsOnBoard = []
        indiciesOfSelectedCards = []
        completedSets = []
        
        let colors = CardColor.allCases
        let symbols = CardSymbol.allCases
        let shadings = CardShading.allCases
        let numbers = CardNumber.allCases
        
        colors.forEach { color in
            symbols.forEach { symbol in
                shadings.forEach { shading in
                    numbers.forEach { number in
                        deck.append(Card(color: color, symbol: symbol, shading: shading, number: number, id: String(color.rawValue + symbol.rawValue + shading.rawValue + number.rawValue)))
                    }
                }
            }
        }
        
        
        deck.shuffle()
        
        dealCards(12)
    }
    
    mutating func selectCard (_ card: Card) {
        if let cardIndex = cardsOnBoard.firstIndex(where: {$0.id == card.id}) {
            if cardsOnBoard[cardIndex].isSelected {
                cardsOnBoard[cardIndex].isSelected = false
                
                indiciesOfSelectedCards.removeAll(where: { $0 == cardIndex })
            } else {
                cardsOnBoard[cardIndex].isSelected = true
                indiciesOfSelectedCards.append(cardIndex)
            }
            
        } else { print("Card: \"\(card.id)\" not found") }
        
        if indiciesOfSelectedCards.count > 2 {
            checkForSet()
        }
        
        // TODO: check # of cards selected
    }
    
    mutating func checkForSet() {
        // get cards + indicies
        let c1 = indiciesOfSelectedCards[0], c2 = indiciesOfSelectedCards[1], c3 = indiciesOfSelectedCards[2]
        let card1 = cardsOnBoard[c1], card2 = cardsOnBoard[c2], card3 = cardsOnBoard[c3]
        
        
        // remove selction
        cardsOnBoard[c1].isSelected = false
        cardsOnBoard[c2].isSelected = false
        cardsOnBoard[c3].isSelected = false
        indiciesOfSelectedCards.removeAll()
        
        
        // check card1|2|3 for set
        if (((card1.color == card2.color && card2.color == card3.color) || (card1.color != card2.color && card2.color != card3.color && card1.color != card3.color)) && // check color
        ((card1.symbol == card2.symbol && card2.symbol == card3.symbol) || (card1.symbol != card2.symbol && card2.symbol != card3.symbol && card1.symbol != card3.symbol)) && // check symbol
        ((card1.shading == card2.shading && card2.shading == card3.shading) || (card1.shading != card2.shading && card2.shading != card3.shading && card1.shading != card3.shading)) && // check shading
        ((card1.number == card2.number && card2.number == card3.number) || (card1.number != card2.number && card2.number != card3.number && card1.number != card3.number))) // check number
        {
            
            // TODO: runtime security refactor
            let newSet = [cardsOnBoard.remove(at: c1), cardsOnBoard.remove(at: c2), cardsOnBoard.remove(at: c3)]
            
            completedSets.append(newSet)
            dealCards(3)
            print("SET")
        } else { print("NO SET!") }
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        
        // TODO: check for empty deck
        for _ in 1...numberOfCards {
            cardsOnBoard.append(deck.removeFirst())
        }
    }
    
    enum CardColor: String, CaseIterable {
        case red, blue, green
    }
    
    enum CardSymbol: String, CaseIterable {
        case squiggle, diamond, oval
    }
    
    enum CardShading: String, CaseIterable {
        case solid, open, striped
    }
    
    enum CardNumber: String, CaseIterable {
        case one, two, three
    }
    
    struct Card: Identifiable {
        let color: CardColor
        let symbol: CardSymbol
        let shading: CardShading
        let number: CardNumber
        var isSelected = false
        var id: String
    }
}
