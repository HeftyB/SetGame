//
//  TopBar.swift
//  Set
//
//  Created by Andrew Shields on 9/27/22.
//

import SwiftUI

struct TopBar: View {
    let score: Int
    let startTime: Date
    @State var playTime = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatter = DateComponentsFormatter()
    let status: String
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                HStack {
                    Text(status)
                        .font(.largeTitle)
                        .foregroundColor(Color.black)
                        .padding(/*@START_MENU_TOKEN@*/.horizontal/*@END_MENU_TOKEN@*/)
                        .background(.white)
                        .border(/*@START_MENU_TOKEN@*/Color(red: 1.0, green: 0.0, blue: 0.0, opacity: 1.0)/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/)
                }
                HStack {
                    Text("\(score) Sets in \(playTime)s")
                        .onReceive(timer) { _ in
                            playTime = formatter.string(from: Date().timeIntervalSince(startTime))!
                        }
                }
            }
            Spacer()
            Deck()
                .foregroundColor(.white)
            Spacer()
            
        }
    }
}

struct TopBar_Previews: PreviewProvider {
    static var previews: some View {
        TopBar(score: SetGameViewModel().completedSetsCount, startTime: Date(), status: "Match!")
            .frame(height: 150)
    }
}
