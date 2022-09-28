//
//  ButtonBar.swift
//  Set
//
//  Created by Andrew Shields on 9/27/22.
//

import SwiftUI

struct ButtonBar: View {
    var game: SetGameViewModel
    
    var body: some View {
        HStack {
            Button(action: game.newGame) {
                Text("New Game")
            }
            .padding()
            .background(.red)
            .border(.black, width: 2)
            
            Button(action: {}) {
                Text("Hint")
            }
            .padding()
            .background(.yellow)
            
            Button(action: game.deal3) {
                Text("Deal 3")
            }
            .padding()
            .background(.blue)
        }
    }
}

struct ButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBar(game: SetGameViewModel())
    }
}
