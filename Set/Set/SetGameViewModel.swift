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
    
    var cards: Array<Card> { model.cardsOnBoard }
    
    var completedSetsCount: Int { model.completedSets.count }
    
    var completedSets: [SetGameModel.CardSet] { model.completedSets }
    
    var startTime: Date { model.startTime }
    
    var status: String {
        switch model.status {
        case .select:
            return "Select a set!"
        case .match:
            return "Set match!"
        case .noMatch:
            return "No match!"
        }
    }
    
    init() {
        model = SetGameModel()
    }
    
    func selectCard(_ card: Card) { model.selectCard(card)}
    
    func deal3(){ model.dealCards(3) }
    
    func newGame() { model = SetGameModel() }
    
    func getHint() {
        if let indicies = model.findSet() {
            model.highlight(index: indicies[0])
            model.highlight(index: indicies[1])
            model.highlight(index: indicies[2])
//            print(indicies)
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
            let s = cardShading(symbol: CardConstants.CardShape1, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        case .nuetral:
            let s = cardShading(symbol: CardConstants.CardShape2, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        case .positive:
            let s = cardShading(symbol: CardConstants.CardShape3, feature: card.feature3, color: color)
            elementReplicator(element: s, count: cardNumber(feature: card.feature4), aspectRatio: ar, color: color)
        }
    }
    
    /// Matches card's feature-state to Color
    /// - Parameter feature: ThreeState representing card's color
    /// - Returns: Color
    private func cardColor(feature: ThreeState) -> Color {
        switch feature {
        case .negative:
            return CardConstants.CardColor1
        case .nuetral:
            return CardConstants.CardColor2
        case .positive:
            return CardConstants.CardColor3
        }
    }
    
    /// Matches card's feature-state to number (# of times CradShape is displayed)
    /// - Parameter feature: ThreeState representing card's number
    /// - Returns: Int
    private func cardNumber(feature: ThreeState) -> Int {
        switch feature {
        case .negative:
            return CardConstants.CardNumber1
        case .nuetral:
            return CardConstants.CardNumber2
        case .positive:
            return CardConstants.CardNumber3
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
        static let cardShapeAspectRatio: CGFloat = 2/1
        static let CardColor1: Color = .red
        static let CardColor2: Color = .blue
        static let CardColor3: Color = Color("CardColor3")
        static let CardNumber1: Int = 1
        static let CardNumber2: Int = 2
        static let CardNumber3: Int = 3
        static let CardShape1 = Diamond()
        static let CardShape2 = CardCapsule()
        static let CardShape3 = Squiggle()
    }
}
