//
//  Deck.swift
//  Set
//
//  Created by Andrew Shields on 9/26/22.
//

import SwiftUI

struct Deck: View {
    var body: some View {
        ZStack {
            Group {
                CardBack()
                CardBack()
                    .offset(x: 2.0, y: 2.0)
                CardBack()
                    .offset(x: 4.0, y: 4.0)
            }
            .aspectRatio(2/3, contentMode: .fit)
        }
    }
}

struct Deck_Previews: PreviewProvider {
    static var previews: some View {
        Deck()
    }
}


struct CardBack: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color("CardBackColor"))
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
            .border(Color("InnerCardBorderColor"), width: 1)
            .padding(1)
            .background(Color("OuterCardBorderColor"))
        }
    }
}

struct CardBack_Previews: PreviewProvider {
    static var previews: some View {
        CardBack()
    }
}
