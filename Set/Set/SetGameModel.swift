//
//  CardGame.swift
//  Set
//
//  Created by Andrew Shields on 8/27/22.
//

import Foundation


struct SetGameModel {
    private (set) var deck: [Card]
    private(set) var cardsOnBoard: [Card]
    private (set) var completedSets: [CardSet]
    private var indiciesOfSelectedCards: [Int]
    let startTime: Date
    private (set) var status: Status = .select
    init() {
        deck = []
        cardsOnBoard = []
        indiciesOfSelectedCards = []
        completedSets = []
        startTime = Date()
        
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
        if status != .select { status = .select }
        if let cardIndex = cardsOnBoard.firstIndex(where: {$0.id == card.id}) {
            cardsOnBoard[cardIndex].isHighlighted = false
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
        var indicies = [ indiciesOfSelectedCards[0], indiciesOfSelectedCards[1], indiciesOfSelectedCards[2] ]
        let card1 = cardsOnBoard[indicies[0]], card2 = cardsOnBoard[indicies[1]], card3 = cardsOnBoard[indicies[2]]
        
        cardsOnBoard[indicies[0]].isSelected = false
        cardsOnBoard[indicies[1]].isSelected = false
        cardsOnBoard[indicies[2]].isSelected = false
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
            indicies.sort()
            let newSet = [cardsOnBoard.remove(at: indicies[2]), cardsOnBoard.remove(at: indicies[1]), cardsOnBoard.remove(at: indicies[0])]
            
            status = .match
            let setId = "\(newSet[0].id)\(newSet[1].id)\(newSet[2].id)"
            let cs = CardSet(card1: newSet[0], card2: newSet[1], card3: newSet[2], id: setId, timeStamp: Date())
            completedSets.append(cs)
            dealCards(3)
        } else { status = .noMatch }
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        if deck.isEmpty { return }
        for _ in 1...min(numberOfCards, deck.count) {
            if deck.isEmpty { break }
            cardsOnBoard.append(deck.removeFirst())
        }
    }
    
    func findSet() -> [Int]? {
        for i in 0..<cardsOnBoard.count {
            for j in (i + 1)..<cardsOnBoard.count {
                let matchID = setMatchCalculator(card1: cardsOnBoard[i], card2: cardsOnBoard[j])
                
                if cardsOnBoard.contains(where: {$0.id == matchID}) {
                    let index = cardsOnBoard.firstIndex(where: {$0.id == matchID})!
                    return [i, j, index, matchID]
                }
            }
        }
        
        return nil
    }
    
    func setMatchCalculator(card1: Card, card2: Card) -> Int {
        // TODO: refactor
        let id1 = card1.id,
            id2 = card2.id,
            c1f1 = id1[3],
            c1f2 = id1[2],
            c1f3 = id1[1],
            c1f4 = id1[0],
            c2f1 = id2[3],
            c2f2 = id2[2],
            c2f3 = id2[1],
            c2f4 = id2[0],
            rf1: Int,
            rf2: Int,
            rf3: Int,
            rf4: Int
        
        if c1f1 == c2f1 {
            rf1 = c1f1 * 1000
        } else {
            var arr = [2, 1, 0]
            arr.remove(at: arr.firstIndex(where: {$0 == c1f1})!)
            arr.remove(at: arr.firstIndex(where: {$0 == c2f1})!)
            rf1 = arr[0] * 1000
        }
        
        if c1f2 == c2f2 {
            rf2 = c1f2 * 100
        } else {
            var arr2 = [2, 1, 0]
            arr2.remove(at: arr2.firstIndex(where: {$0 == c1f2})!)
            arr2.remove(at: arr2.firstIndex(where: {$0 == c2f2})!)
            rf2 = arr2[0] * 100
        }
        
        if c1f3 == c2f3 {
            rf3 = c1f3 * 10
        } else {
            var arr3 = [2, 1, 0]
            arr3.remove(at: arr3.firstIndex(where: {$0 == c1f3})!)
            arr3.remove(at: arr3.firstIndex(where: {$0 == c2f3})!)
            rf3 = arr3[0] * 10
        }
        
        if c1f4 == c2f4 {
            rf4 = c1f4
        } else {
            var arr4 = [2, 1, 0]
            arr4.remove(at: arr4.firstIndex(where: {$0 == c1f4})!)
            arr4.remove(at: arr4.firstIndex(where: {$0 == c2f4})!)
            rf4 = arr4[0]
        }
        return rf1 + rf2 + rf3 + rf4
    }
    
    mutating func highlight(index: Int) {
        cardsOnBoard[index].isHighlighted = true
    }
    
    enum Status: String {
        case select, match, noMatch
    }
    
    struct Card: Identifiable {
        let feature1: ThreeState
        let feature2: ThreeState
        let feature3: ThreeState
        let feature4: ThreeState
        var isSelected = false
        var isHighlighted = false
        var id: Int
    }
    
    struct CardSet: Identifiable {
        let card1: Card
        let card2: Card
        let card3: Card
        let id: String
        let timeStamp: Date
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
            /// divide the number bu the base, the division remainder is
            /// the ternery digit starting from the right  with the  division result
            ///  carrying over to the next iteration. 
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
