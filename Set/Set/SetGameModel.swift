//
//  CardGame.swift
//  Set
//
//  Created by Andrew Shields on 8/27/22.
//

import Foundation


struct SetGameModel {
    private (set) var gameCards: [Card]
    private (set) var completedSets: [CardSet]
    private var indiciesOfSelectedCards: [Int]
    let startTime: Date
    
    private var cardsOnBoard: [Card] {
        gameCards.filter({$0.isActive && !$0.isDiscarded})
    }
    
    var isSelectedFull: Bool {
        indiciesOfSelectedCards.count > 2
    }
    
    init() {
        gameCards = []
        indiciesOfSelectedCards = []
        completedSets = []
        startTime = Date()
        
        for i in 1...81 {
            /// card features permutation
            let ternaryNum = i.baseRepresentable(number: i, base: 3)

            gameCards.append(Card(status: SetGameModel.Card._UIDeafault, id: ternaryNum))
        }
        gameCards.shuffle()
    }
    
    mutating func selectCard (_ card: Card) {
        if let cardIndex = gameCards.firstIndex(where: {$0.id == card.id}) {
            gameCards[cardIndex].isHighlighted = false
            if gameCards[cardIndex].isSelected {
                gameCards[cardIndex].isSelected = false
                
                indiciesOfSelectedCards.removeAll(where: { $0 == cardIndex })
            } else {
                gameCards[cardIndex].isSelected = true
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
        let card1 = gameCards[indicies[0]], card2 = gameCards[indicies[1]], card3 = gameCards[indicies[2]]
        
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
            let newSet = [ gameCards[indicies[2]], gameCards[indicies[1]], gameCards[indicies[0]] ]
            
            let setId = "\(newSet[0].id)\(newSet[1].id)\(newSet[2].id)"
            
            for i in indiciesOfSelectedCards {
                gameCards[i].setMatched = true
            }
            
            let cs = CardSet(card1: newSet[0], card2: newSet[1], card3: newSet[2], id: setId, timeStamp: Date())
            completedSets.append(cs)
        } else {
            for i in indiciesOfSelectedCards {
                gameCards[i].setUnmatched = true
            }
        }
    }
    
    mutating func clearSelectedCards() {
        for i in indiciesOfSelectedCards {
            gameCards[i].isSelected = false
            if gameCards[i].setMatched { gameCards[i].setMatched = false }
            if gameCards[i].setUnmatched { gameCards[i].setUnmatched = false }
        }
        indiciesOfSelectedCards.removeAll()
    }
    
    mutating func dealCards(_ numberOfCards: Int) {
        let newDiscard = gameCards.filter { $0.isDiscarded && $0.isActive }
        for card in newDiscard {
            let cardIndex = gameCards.firstIndex(where: {$0.id == card.id})!
            gameCards[cardIndex].isActive = false
        }
        var deck = gameCards.filter { !$0.isActive && !$0.isDiscarded }
        if deck.isEmpty { return }
        for _ in 1...min(numberOfCards, deck.count) {
            if deck.isEmpty { break }
            let c = deck.removeFirst()
            let ci = gameCards.firstIndex(where: {$0.id == c.id})!
            gameCards[ci].isActive = true
            
        }
    }
    
    mutating func flipCard(_ card: Card) {
        if let cardIndex = gameCards.firstIndex(where: {$0.id == card.id}) {
            gameCards[cardIndex].isFaceUp = true
        }
    }
    
    mutating func discardCard(_ card: Card) {
        if let cardIndex = gameCards.firstIndex(where: {$0.id == card.id}) {
            gameCards[cardIndex].isDiscarded = true
        }
    }
    
    func findSet() -> [Int]? {
        for i in 0..<cardsOnBoard.count {
            for j in (i + 1)..<cardsOnBoard.count {
                let matchID = setMatchCalculator(card1: cardsOnBoard[i], card2: cardsOnBoard[j])
                if cardsOnBoard.contains(where: {$0.id == matchID}) {
                    let matchIndex = gameCards.firstIndex(where: {$0.id == matchID})!
                    let c1Index = gameCards.firstIndex(where: {$0.id == cardsOnBoard[i].id})!
                    let c2Index = gameCards.firstIndex(where: {$0.id == cardsOnBoard[j].id})!
                    return [c1Index, c2Index, matchIndex, matchID]
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
        gameCards[index].isHighlighted = true
    }
    
    enum Status: String {
        case select, match, noMatch
    }
    
    struct Card: Identifiable, Equatable {
        var status: UInt8
        var id: Int
    }
    
    struct CardSet: Identifiable {
        let card1: Card
        let card2: Card
        let card3: Card
        let id: String
        let timeStamp: Date
        
        init(card1: Card, card2: Card, card3: Card, id: String, timeStamp: Date) {
            var c1 = card1
            var c2 = card2
            var c3 = card3
            
            c1.status = Card._UIFaceUp
            c2.status = Card._UIFaceUp
            c3.status = Card._UIFaceUp
            
            self.card1 = c1
            self.card2 = c2
            self.card3 = c3
            self.id = id
            self.timeStamp = timeStamp
        }
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
    
    func toThreeState() -> ThreeState {
        if self == 0 { return .negative }
        else if self == 1 { return .nuetral }
        else { return .positive }
    }
}

extension SetGameModel.Card {
    var feature1: ThreeState {
        id[3].toThreeState()
    }
    
    var feature2: ThreeState {
        id[2].toThreeState()
    }
    
    var feature3: ThreeState {
        id[1].toThreeState()
    }
    
    var feature4: ThreeState {
        id[0].toThreeState()
    }
    
    var isActive: Bool {
        get {
            var r = status & 0b10000000
            r >>= 7
            return r.toBool()
        }
        set {
            var s = status << 1
            s >>= 1
            if newValue {
                status = s.clearedBitToTrue()
            } else {
                status = s | 0b10000000
            }
        }
    }
    
    var isFaceUp: Bool {
        get {
            var r = status & 0b01000000
            r >>= 6
            return r.toBool()
        }
        set {
            let s = status & 0b10111111 /// clear bits
            if newValue {
                status = s.clearedBitToTrue() /// set new  bit to true
            } else {
                status = s | 0b01000000 /// set new bit to false
            }
        }
    }
    
    var isSelected: Bool {
        get {
            var r = status & 0b00100000
            r >>= 5
            return r.toBool()
        }
        set {
            let s = status & 0b11011111
            if newValue {
                status = s.clearedBitToTrue()
            } else {
                status = s | 0b00100000
            }
        }
    }
    
    var setMatched: Bool {
        get {
            var r = status & 0b00010000
            r >>= 4
            return r.toBool()
        }
        set {
            let s = status & 0b11101111
            if newValue {
                status = s.clearedBitToTrue()
            } else {
                status = s | 0b00010000
            }
        }
    }
    
    
    
    var setUnmatched: Bool {
        get {
            var r = status & 0b00001000
            r >>= 3
            return r.toBool()
        }
        set {
            let s = status & 0b11110111
            if newValue {
                status = s.clearedBitToTrue()
            } else {
                status = s | 0b00001000
            }
        }
    }
    
    var isHighlighted: Bool {
        get {
            var r = status & 0b00000100
            r >>= 2
            return r.toBool()
        }
        set {
            let s = status & 0b11111011
            if newValue {
                status = s.clearedBitToTrue()
            } else {
                status = s | 0b00000100
            }
        }
    }
        
    var isDiscarded: Bool {
        get {
            let r = status & 0b00000001
            return r.toBool()
        }
        set {
            var s = status >> 2 /// clear the bit
            s <<= 2
            
            if newValue {
                status = s.clearedBitToTrue()  /// set new bit to true
            } else {
                status = s | 0b00000001 /// set new bit to false
            }
        }
    }
    
    static let _UIDeafault: UInt8 = 0b11111111
    static let _UIFaceUp: UInt8 = 0b10111111
}

extension UInt8 {
    func toBool() -> Bool {
        if self == 0b00000000 {
            return true
        } else {
            return false
        }
    }
    
    func clearedBitToTrue() -> UInt8 {
        return self | 0b00000000
    }
}
