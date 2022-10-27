//
//  SetGameViewModel.swift
//  Set
//
//  Created by Andrew Shields on 8/30/22.
//

import Foundation
import SwiftUI

class SetGameViewModel: ObservableObject {
    @Published var model: SetGameModel
    
    typealias Card = SetGameModel.Card
    
    var cards: Array<Card> { model.gameCards }
    
    var completedSetsCount: Int { model.completedSets.count }
    
    var completedSets: [SetGameModel.CardSet] { model.completedSets }
    
    var startTime: Date { model.startTime }
    
    var deck: [Card] {
        model.gameCards.filter {
            !$0.isActive && !$0.isDiscarded
        }
    }
    
    var cardsOnBoard: [Card] {
        model.gameCards.filter {
            $0.isActive
        }
    }
    
    var discard: [Card] {
        model.gameCards.filter {
            !$0.isActive && $0.isDiscarded
        }
    }
    
    init() {
        model = SetGameModel()
    }
    
    func selectCard(_ card: Card) {
        model.selectCard(card)
        if model.isSelectedFull {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                self.model.clearSelectedCards()
            }
        }
    }
    
    func discardCard(_ card: Card) { model.discardCard(card) }
    
    func deal() { model.dealCards(1) }
    
    func deal3(){ model.dealCards(3) }
    
    func flipCard(_ card: Card) { model.flipCard(card) }
    
    func initialDraw() { model.dealCards(12) }
    
    func newGame() { model = SetGameModel() }
    
    func getHint() {
        if let indicies = model.findSet() {
            model.highlight(index: indicies[0])
            model.highlight(index: indicies[1])
            model.highlight(index: indicies[2])
        } else {
            print("Not Found!")
        }
    }
    
    /// ///                            |       .negative       |       .nuetral       |       .positive
    ///  ----------------------------------------------------
    /// Feature1: Color            red                          blue                       green
    /// Feature2: Symbol        diamond                 capsule                 squiggle
    /// Feature3: Shading       filled                       striped                   open
    /// Feature4: Number            1                           2                           3
    /// - Parameter card: SetGameModel.Card to be dispayed
    /// - Returns: VStack containing the card's CardShape
    @ViewBuilder func cardFeatureBuilder(card: Card) -> some View {
        let color = cardColor(feature: card.feature1)
        let ar = CardConstants.cardShapeAspectRatio
        
        switch card.feature2 {
        case .negative:
            let s = cardShading(symbol: CardConstants.cardShape1, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        case .nuetral:
            let s = cardShading(symbol: CardConstants.cardShape2, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        case .positive:
            let s = cardShading(symbol: CardConstants.cardShape3, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        }
    }
    
    /// Matches card's feature-state to Color
    /// - Parameter feature: ThreeState representing card's color
    /// - Returns: Color
    private func cardColor(feature: ThreeState) -> Color {
        switch feature {
        case .negative:
            return CardConstants.cardColor1
        case .nuetral:
            return CardConstants.cardColor2
        case .positive:
            return CardConstants.cardColor3
        }
    }
    
    /// Matches card's feature-state to number (# of times CradShape is displayed)
    /// - Parameter feature: ThreeState representing card's number
    /// - Returns: Int
    private func cardNumber(feature: ThreeState) -> Int {
        switch feature {
        case .negative:
            return CardConstants.cardNumber1
        case .nuetral:
            return CardConstants.cardNumber2
        case .positive:
            return CardConstants.cardNumber3
        }
    }
    
    /// Shades card's CardShape (Stroked, Filled, Striped)
    /// - Parameters:
    ///   - symbol: CardShape to be shaded
    ///   - feature: feature description
    ///   - color: ThreeState representing card's shading
    /// - Returns: CardShape stroked, filled, or striped
    @ViewBuilder private func cardShading<T: CardShape>(symbol: T, feature: ThreeState, color: Color) -> some View {
        switch feature {
        case .negative:
            symbol
                .fill(color)
        case .nuetral:
            stripe(symbol: symbol)
                .stroke(color, lineWidth: 1)
        case .positive:
            symbol
                .stroke(color)
        }
    }
    
    /// Toggles CardShape's striped property
    /// - Parameter symbol: CardShape to be striped
    /// - Returns: CardShape view striped
    private func stripe<T: CardShape>(symbol: T) -> T{
        var s = symbol
        s.striped = true
        return s
    }
    
    /// Replicates element passed in up to 3 times & applies an aspect ratio view modifier
    /// - Parameters:
    ///   - element: Element to be replicated
    ///   - count: # of times element should appear in returned VStack
    /// - Returns: VStack containing the Element replicated
    @ViewBuilder func elementReplicator<T: View>(element: T, count: Int, aspectRatio ar: CGFloat, color: Color) -> some View {
        let arElement = element.aspectRatio(ar, contentMode: .fit)
        
        VStack(spacing: 0) {
            Spacer(minLength: 0)
                Divider()
                    .frame(height: 4)
                    .overlay(color)
                arElement
            if count > 1 {
                    Divider()
                        .frame(height: 4)
                        .overlay(color)
                    arElement
            }
            if count > 2 {
                    Divider()
                        .frame(height: 4)
                        .overlay(color)
                    arElement
            }
                Divider()
                    .frame(height: 4)
                    .overlay(color)
            Spacer(minLength: 0)
        }
    }
    
    struct CardConstants {
        static let cardAspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 7.5
        static let cardShapeAspectRatio: CGFloat = 2/1
        static let cardColor1: Color = .red
        static let cardColor2: Color = .blue
        static let cardColor3: Color = Color("CardColor3")
        static let cardNumber1: Int = 1
        static let cardNumber2: Int = 2
        static let cardNumber3: Int = 3
        static let cardShape1 = Diamond()
        static let cardShape2 = CardCapsule()
        static let cardShape3 = Squiggle()
        static let dealDuration = 1.1
        static let cardFlipDuration = 1.0
        static let cardMatchDuration = 0.5
        static let cardUnMatchDuration = 0.5
        static let discardDuration = 1.0
    }
}
