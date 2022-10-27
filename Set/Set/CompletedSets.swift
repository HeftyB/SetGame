//
//  CompletedSets.swift
//  Set
//
//  Created by Andrew Shields on 10/2/22.
//

import SwiftUI

struct CompletedSets: View {
    let game: SetGameViewModel
    let aspectRatio = SetGameViewModel.CardConstants.cardAspectRatio
    let formatter: DateComponentsFormatter =
    {
        var f = DateComponentsFormatter()
        f.allowedUnits = [.second, .minute, .hour]
        f.maximumUnitCount = 1
        f.unitsStyle = .abbreviated
        f.zeroFormattingBehavior = .dropAll
        return f
    }()
    
    
    var body: some View {
        HStack {
            Divider()
            ScrollView {
                Group {
                    Text("Completed Sets:")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    .padding()
                    
                    Divider()
                        .frame(height: 4)
                }
                
                ForEach(game.completedSets) { cardSet in
                    VStack(spacing: 0) {
                        HStack {
                            Card(card: cardSet.card1, cardShape: game.cardFeatureBuilder(card: cardSet.card1))
                            Card(card: cardSet.card2, cardShape: game.cardFeatureBuilder(card: cardSet.card2))
                            Card(card: cardSet.card3, cardShape: game.cardFeatureBuilder(card: cardSet.card3))
                        }
                        HStack {
                            Spacer()
                            Text("Completed \(formatter.string(from: Date().timeIntervalSince(cardSet.timeStamp))!) ago")
                                .font(.footnote)
                                .fontWeight(.medium)
                                .padding([.bottom, .trailing], 4.0)
                        }
                    }
                    .border(Color("OuterCardBorderColor"))
                    .background(Color("BoardColor"))
                    .padding()
                }
            }
            Divider()
        }
        
        .background(Color("Color 1"))
    }
}

struct CompletedSets_Previews: PreviewProvider {
    static var previews: some View {
        CompletedSets(game: SetGameViewModel())
    }
}
