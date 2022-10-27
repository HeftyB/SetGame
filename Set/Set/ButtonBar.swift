//
//  ButtonBar.swift
//  Set
//
//  Created by Andrew Shields on 9/27/22.
//

import SwiftUI

struct ButtonBar: View {
    var game: SetGameViewModel
    @State private var showingRules = false
    
    var body: some View {
        HStack {
            Button(action: game.newGame) {
                VStack {
                    Image(systemName: "plus.circle")
                        .foregroundColor(.red)
                    Text("Reset")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: { showingRules.toggle() }) {
                VStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.yellow)
                    Text("Rules")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: game.getHint) {
                VStack {
                    Image(systemName: "suit.diamond")
                        .foregroundColor(.yellow)
                    Text("Hint")
                        .font(.caption2)
                }
            }
        }
        .padding()
        .background(Color("ButtonBarBackgroundColor"))
        .cornerRadius(10)
        .sheet(isPresented: $showingRules) {
            Rules(game: game)
        }
    }
}

struct ButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBar(game: SetGameViewModel())
    }
}
