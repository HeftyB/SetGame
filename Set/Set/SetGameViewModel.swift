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
    
    init() {
        model = SetGameModel()
    }
    
    func selectCard(_ card: Card) { model.selectCard(card)}
    
    func deal3(){ model.dealCards(3) }
    
//    func cardFeatureBuilder(card: Card) {
//        //TODO: take in card and returns the appropriate Card features
//    }
}
