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
            Spacer()
            Button(action: game.newGame) {
                VStack {
                    Image(systemName: "plus.circle")
                    Text("New Game")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: {}) {
                VStack {
                    Image(systemName: "checkmark.circle")
                    Text("Sets")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: game.getHint) {
                VStack {
                    Image(systemName: "suit.diamond")
                    Text("Hint")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: game.deal3) {
                VStack {
                    Image(systemName: "rectangle.portrait")
                    Text("Deal 3")
                        .font(.caption2)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color("ButtonBarBackgroundColor"))
    }
}

struct ButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBar(game: SetGameViewModel())
    }
}
