//
//  AspectCard.swift
//  Set
//
//  Created by Andrew Shields on 10/2/22.
//

import SwiftUI

struct Cardify: Animatable, ViewModifier {
    
    var aspectRatio: CGFloat
    var padding: CGFloat?
    var yRotation: Double
    var xRotation: Double
    var xOffset: Double
    var yOffset: Double
    var scale: Double
    var foregroundColor: Color
    
    typealias Constant = SetGameViewModel.CardConstants
    
    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        get {
            AnimatablePair(scale, AnimatablePair(yRotation, xRotation))
        }
        set {
            scale = newValue.first
            yRotation = newValue.second.first
            xRotation = newValue.second.second
        }
    }
    
    init(isFaceUp: Bool, isSelected: Bool, setMatched: Bool, setUnmatched: Bool, isHighlighted: Bool, aspectRatio: CGFloat = Constant.cardAspectRatio, padding: CGFloat? = nil) {
        self.aspectRatio = aspectRatio
        self.padding = padding
        yRotation = isFaceUp ? 0 : 180
        self.foregroundColor = {
            if isHighlighted { return Color("CardHighlightColor") }
            else if setUnmatched { return .red }
            else if isSelected { return Color("CardSelectionColor") }
            else { return Color.accentColor }
        }()
        
        
        scale = isSelected ? 1.25 : 1
        
        yOffset = 0
        
        xOffset = 0
        
        xRotation = 0
    }
    
    func body(content: Content) -> some View {
        ZStack {
            
            let cardBack = RoundedRectangle(cornerRadius: SetGameViewModel.CardConstants.cornerRadius)
            
            if yRotation < 90 {
                cardBack
                    .foregroundColor(foregroundColor)
                cardBack.strokeBorder(lineWidth: 3)
                
            } else {
                cardBack
                    .fill()
                    .foregroundColor(Color("CardBackColor"))
        
                cardBackCircle
            }
            
            content
                .opacity(yRotation < 90 ? 1 : 0)
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .scaleEffect(scale)
        
        .rotation3DEffect(Angle.degrees(yRotation), axis: (0, 1, 0))
    }
    
    
    var cardBackCircle: some View {
        ZStack {
            
                
            Circle()
                .fill(Color("OuterCardBorderColor"))
                .padding(2)
            Circle()
                .fill(Color("CardBackCenterColor"))
                .padding(4)
            Image("CardLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
        .border(Color("CardBackInnerBorderColor"), width: 1)
        .padding(1)
        .background(Color("CardBackOuterBorderColor"))
        
    }
}

extension View {
    func aspectCardify(card: SetGameModel.Card, padding: CGFloat?) -> some View {
        self.modifier(Cardify(isFaceUp: card.isFaceUp, isSelected: card.isSelected, setMatched: card.setMatched, setUnmatched: card.setUnmatched, isHighlighted: card.isHighlighted, padding: padding))
    }
}
