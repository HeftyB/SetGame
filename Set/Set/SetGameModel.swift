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
        
        let ts = ThreeState.allCases
        
        ////        var i will represent the Nth card of the deck
        ////        with 4 fefatures, each containing three states == total 81 unique combinations / cards
        ////        to advoid any nested loops we will represent each possible "feature-state" as a digit in a Base3 (ternary) number
        ////        with the first card represented as 10000 and last card 02222
        ////        if we store the result of ThreeState.allCases we can use each individual digit in the Base3 number as an index value and systematically
        ////        create every single possible combination of card.
        for i in 1...81 {
            let ternaryNum = i.baseRepresentable(number: i, base: 3)

            deck.append(Card(feature1: ts[ternaryNum[3]], feature2: ts[ternaryNum[2]], feature3: ts[ternaryNum[1]], feature4: ts[ternaryNum[0]], id: ternaryNum))
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
    }
    
    mutating func checkForSet() {
        /// get cards + indicies & remove selection
        let c1 = indiciesOfSelectedCards[0], c2 = indiciesOfSelectedCards[1], c3 = indiciesOfSelectedCards[2]
        let card1 = cardsOnBoard[c1], card2 = cardsOnBoard[c2], card3 = cardsOnBoard[c3]
        
        cardsOnBoard[c1].isSelected = false
        cardsOnBoard[c2].isSelected = false
        cardsOnBoard[c3].isSelected = false
        indiciesOfSelectedCards.removeAll()
        
        /// check card1|2|3 for set
        if (((card1.feature1 == card2.feature1 && card2.feature1 == card3.feature1) ||
             (card1.feature1 != card2.feature1 && card2.feature1 != card3.feature1 && card1.feature1 != card3.feature1)) && //// check feature1
             ((card1.feature2 == card2.feature2 && card2.feature2 == card3.feature2) ||
             (card1.feature2 != card2.feature2 && card2.feature2 != card3.feature2 && card1.feature2 != card3.feature2)) && //// check feature2
             ((card1.feature3 == card2.feature3 && card2.feature3 == card3.feature3) ||
             (card1.feature3 != card2.feature3 && card2.feature3 != card3.feature3 && card1.feature3 != card3.feature3)) && //// check feature3
             ((card1.feature4 == card2.feature4 && card2.feature4 == card3.feature4) ||
             (card1.feature4 != card2.feature4 && card2.feature4 != card3.feature4 && card1.feature4 != card3.feature4))) //// check feature4
        {
            let newSet = [cardsOnBoard.remove(at: c1), cardsOnBoard.remove(at: c2), cardsOnBoard.remove(at: c3)]
            
            completedSets.append(newSet)
            dealCards(3)
        } else { print("NO SET!") }
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        for _ in 1...min(numberOfCards, deck.count) {
            cardsOnBoard.append(deck.removeFirst())
        }
    }
    
    struct Card: Identifiable {
        let feature1: ThreeState
        let feature2: ThreeState
        let feature3: ThreeState
        let feature4: ThreeState
        var isSelected = false
        var id: Int
    }
}

enum ThreeState: String, CaseIterable {
    case negative, nuetral, positive
}

extension Int {
    /// - Parameters:
    ///   - number: number to convert
    ///   - base: number base to convert to
    /// - Returns: a representative value of an integar in BaseX form
    /// Example:  baseRepresentable(number: 81, base: 3) -> 10000
    func baseRepresentable(number: Int, base: Int) -> Int {
        var returnValue: [Int] = []
        var n = number
        
        while n > 0 {
            let r = n % base
            returnValue.insert(r, at: 0)
            n /= base
        }
        
        return returnValue.reduce(0) { return $0 * 10 + $1 }
    }
    
    /// Make it  easier to access the  individual digits in an int
    subscript(digitIndex: Int) -> Int {
            var decimalBase = 1
            for _ in 0..<digitIndex {
                decimalBase *= 10
            }
            return (self / decimalBase) % 10
        }
}
