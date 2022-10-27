//
//  Rules.swift
//  Set
//
//  Created by Andrew Shields on 10/4/22.
//

import SwiftUI
import WebKit

struct Rules: View {
    typealias MCard = SetGameModel.Card
    var game: SetGameViewModel
    @State private var showWiki = false
    
    var body: some View {
        VStack {
            Text("Each card has 4 features")
                .font(.title)
            List {
                setOfCards(c1: displayCards.color1, c2: displayCards.color2, c3: displayCards.color3, label: "Color:")
                setOfCards(c1: displayCards.shape1, c2: displayCards.shape2, c3: displayCards.shape3, label: "Shape:")
                setOfCards(c1: displayCards.shading1, c2: displayCards.shading2, c3: displayCards.shading3, label: "Shading:")
                setOfCards(c1: displayCards.number1, c2: displayCards.number2, c3: displayCards.number3, label: "Number:")
            }
            
            VStack(alignment: .leading) {
                Text("A set is composed of 3 cards where each one of the four features are either similar or all are different.")
                    .font(.headline)
                Divider()
                Text("The general rule of thumb is \"If two cards are something and one is not, it's not a set\"")
                    .padding(2)
                    .border(.black)
            }
            .padding()
            
            Button(action: { showWiki.toggle() }) {
                Text("Learn More!")
            }
            .padding()
            .background(.blue)
            .cornerRadius(10)
        }
        .sheet(isPresented: $showWiki) {
            RulesWikiWebView()
        }
    }
    
    @ViewBuilder private func setOfCards(c1: MCard, c2: MCard, c3: MCard, label: String) -> some View {
        VStack(alignment: .leading) {
            Text(label)
                .fontWeight(.bold)
            HStack {
                Card (card: c1, cardShape: game.cardFeatureBuilder(card: c1))
                Card (card: c2, cardShape: game.cardFeatureBuilder(card: c2))
                Card (card: c3, cardShape: game.cardFeatureBuilder(card: c3))
            }
            
            .padding(.horizontal)
        }
        .border(Color("OuterCardBorderColor"))
    }
    
    private struct displayCards {
        static let status = SetGameModel.Card._UIFaceUp
        
        static let color1 = MCard(status: status, id: 0)
        static let color2 = MCard(status: status , id: 1000)
        static let color3 = MCard(status: status , id: 2000)
        
        static let shape1 = MCard(status: status , id: 1000)
        static let shape2 = MCard(status: status , id: 1100)
        static let shape3 = MCard(status: status , id: 1200)
        
        static let shading1 = MCard(status: status , id: 1000)
        static let shading2 = MCard(status: status , id: 1010)
        static let shading3 = MCard(status: status , id: 1020)
        
        static let number1 = MCard(status: status , id: 1000)
        static let number2 = MCard(status: status , id: 1001)
        static let number3 = MCard(status: status , id: 1002)
//
//        static let color1 = MCard(feature1: .negative, feature2: .negative, feature3: .negative, feature4: .negative, status: status, id: 1)
//        static let color2 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .negative, status: status , id: 2)
//        static let color3 = MCard(feature1: .positive, feature2: .negative, feature3: .negative, feature4: .negative, status: status , id: 3)
//
//        static let shape1 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .negative, status: status , id: 4)
//        static let shape2 = MCard(feature1: .nuetral, feature2: .nuetral, feature3: .negative, feature4: .negative, status: status , id: 5)
//        static let shape3 = MCard(feature1: .nuetral, feature2: .positive, feature3: .negative, feature4: .negative, status: status , id: 6)
//
//        static let shading1 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .negative, status: status , id: 7)
//        static let shading2 = MCard(feature1: .nuetral, feature2: .negative, feature3: .nuetral, feature4: .negative, status: status , id: 8)
//        static let shading3 = MCard(feature1: .nuetral, feature2: .negative, feature3: .positive, feature4: .negative, status: status , id: 9)
//
//        static let number1 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .negative, status: status , id: 9)
//        static let number2 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .nuetral, status: status , id: 10)
//        static let number3 = MCard(feature1: .nuetral, feature2: .negative, feature3: .negative, feature4: .positive, status: status , id: 11)
    }
    
}

struct Rules_Previews: PreviewProvider {
    static var previews: some View {
        Rules(game: SetGameViewModel())
    }
}

struct RulesWikiWebView: UIViewRepresentable {
    typealias UIViewType = WKWebView
    
    let webView: UIViewType
    
    init() {
        webView = WKWebView(frame: .zero)
        webView.load(URLRequest(url: URL(string: "https://en.wikipedia.org/wiki/Set_(card_game)")!))
    }
    
    func makeUIView(context: Context) -> WKWebView {
        webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
}
