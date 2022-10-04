//
//  ButtonBar.swift
//  Set
//
//  Created by Andrew Shields on 9/27/22.
//

import SwiftUI

struct ButtonBar: View {
    var game: SetGameViewModel
    @State private var showingCompleted = false
    
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
            Button(action: {}) {
                VStack {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(.yellow)
                    Text("Rules")
                        .font(.caption2)
                }
            }
            Spacer()
            Button(action: { showingCompleted.toggle() }) {
                VStack {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.green)
                    Text("Sets")
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
            Spacer()
            Button(action: game.deal3) {
                VStack {
                    Image(systemName: "rectangle.portrait")
                        .foregroundColor(Color("CardBackColor"))
                    Text("+ 3")
                        .font(.caption2)
                }
            }
        }
        .padding()
        .background(Color("ButtonBarBackgroundColor"))
        .cornerRadius(10)
        .sheet(isPresented: $showingCompleted) {
            CompletedSets(game: game)
        }
    }
}

struct ButtonBar_Previews: PreviewProvider {
    static var previews: some View {
        ButtonBar(game: SetGameViewModel())
    }
}
