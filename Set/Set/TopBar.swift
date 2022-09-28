//
//  TopBar.swift
//  Set
//
//  Created by Andrew Shields on 9/27/22.
//

import SwiftUI

struct TopBar: View {
    var game:SetGameViewModel
    
    var body: some View {
        HStack {
            Divider()
            VStack {
                HStack {
                    Text("Match!")
                        .font(.largeTitle)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .border(/*@START_MENU_TOKEN@*/Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
//                                Text("- 0:30")
                }
                HStack {
                    Text("\(game.completedSets()) Sets in \"Time\"")
                }
            }
            Divider()
            Deck()
                .foregroundColor(.white)
            Divider()
            
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(game: SetGameViewModel())
    }
}
