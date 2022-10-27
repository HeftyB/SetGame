//
//  ContentView.swift
//  Set
//
//  Created by Andrew Shields on 8/26/22.
//

import SwiftUI

struct ContentView: View {
    @Namespace var dealingNameSpace
    @Namespace var discardNameSpace
    typealias CardConstants = SetGameViewModel.CardConstants
    
    @ObservedObject var game: SetGameViewModel
    
    @State private var start = true
    @State private var showingCompleted = false
    @State var playTime = ""
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let formatter = DateComponentsFormatter()
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                Divider()
                VStack {
                    Divider()
                    
                    /// calculate the num of columns and minimum card width for game body
                    let columnNum = sqrt(Double(max(game.cardsOnBoard.count, 16)))
                    let minCardWidth = (min(geometry.size.width, geometry.size.height) * 0.80) / ceil(columnNum)
                    gameBody(minWidth: minCardWidth)

                    Spacer(minLength: .zero)
                    
                    HStack {
                        VStack {
                            /// timer
                            Text("\(game.completedSetsCount) Sets in \(playTime)s")
                                .font(.footnote)
                                .onReceive(timer) { _ in
                                    playTime = formatter.string(from: Date().timeIntervalSince(game.startTime))!
                                }
                            
                            ButtonBar(game: game)
                                .padding(.horizontal)
                        }
                        
                        /// deck & discard
                        HStack {
                            discard
                            Spacer()
                            deck
                                .foregroundColor(.white)
                        }
                        .frame(width: geometry.size.width * 0.30, height: geometry.size.height * 0.1 )
                        .padding(.trailing)
                    }
                    Divider()
                }
                Divider()
            }
            .background(RadialGradient(colors: [Color("BoardColor"), .black], center: .center, startRadius: min(geometry.size.width, geometry.size.height) * 0.9, endRadius: min(geometry.size.width, geometry.size.height) * 2.3))
        }
        .sheet(isPresented: $showingCompleted) {
            CompletedSets(game: game)
        }
    }
    
    @ViewBuilder private func gameBody(minWidth: CGFloat) -> some View {
        VStack {
            LazyVGrid(columns: [{ var g = GridItem(.adaptive(minimum: minWidth))
                g.spacing = 0
                return g
            }() ]) {
                ForEach(game.cardsOnBoard) { card in
                    
                    /// clear square to occupy space until next card draw
                    if card.isDiscarded {
                        Color.clear
                    } else if card.isActive {
                        Card(card: card,
                             cardShape: game.cardFeatureBuilder(card: card))
                        .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                        .matchedGeometryEffect(id: card.id, in: discardNameSpace)
                        .transition(.identity)
                        .padding(4)
                        .rotationEffect(card.setMatched ? Angle.degrees(365) : Angle.degrees(0))
                        .animation(
                            .linear(duration: CardConstants.cardMatchDuration),
                            value: card.setMatched
                        )
                        .rotationEffect(card.setUnmatched ? Angle.degrees(45) : Angle.degrees(0))
                        .animation(
                            .linear(duration: CardConstants.cardUnMatchDuration),
                            value: card.setUnmatched
                        )
                        .zIndex(zIndex(of: card))
                        .onTapGesture {
                            withAnimation {
                                if !card.isFaceUp {
                                    game.flipCard(card)
                                } else {
                                    game.selectCard(card)
                                }
                            }
                        }
                        .onChange(of: card.setMatched, perform: { _ in
                            /// delay of discard transistion to let match animation finish animating
                            DispatchQueue.main.asyncAfter(deadline: .now() + CardConstants.cardMatchDuration) {
                                withAnimation(Animation.linear(duration: CardConstants.discardDuration)) {
                                    game.discardCard(card)
                                }
                            }
                            
                        })
                        .onAppear {
                            withAnimation(flipAnimation(for: card)) {
                                game.flipCard(card)
                            }
                        }
                    }

                }
            }
        }
        .foregroundColor(Color("CardBackColor"))
        .background(Color.clear)
        .padding(.horizontal)
    }
    
    
    var discard: some View {
        ZStack {
            Rectangle()
                .stroke()
                .padding(-4)
                .aspectRatio(SetGameViewModel.CardConstants.cardAspectRatio, contentMode: .fit)
            ForEach(game.cards) { card in
                if !card.isDiscarded {
                    Color.clear
                } else {
                    Card(card: card, cardShape: game.cardFeatureBuilder(card: card))
                        .matchedGeometryEffect(id: card.id, in: discardNameSpace)
                        .transition(.identity)
                }
            }
        }
        .aspectRatio(SetGameViewModel.CardConstants.cardAspectRatio, contentMode: .fit)
        .onTapGesture {
            showingCompleted.toggle()
        }
    }
    
    
    var deck: some View {
        ZStack {
            Group {
                Rectangle()
                    .stroke()
                    .padding(-4)
                    .aspectRatio(SetGameViewModel.CardConstants.cardAspectRatio, contentMode: .fit)
                
                ForEach(game.deck) { card in
                    if !card.isActive {
                        Card(card: card, cardShape: game.cardFeatureBuilder(card: card))
                            .matchedGeometryEffect(id: card.id, in: dealingNameSpace)
                            .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                            .zIndex(zIndex(of: card))
                    }
                }
            }
        }
        .onTapGesture {
            if game.cardsOnBoard.isEmpty {
                /// initial draw
                for i in 0..<12 {
                    let card = game.deck[i]
                    withAnimation(dealAnimation(for: card, total: 12)) {
                        game.deal()
                    }
                }
            } else {
                for i in 0..<3 {
                    if i >= game.deck.count { break }
                    let card = game.deck[i]
                    withAnimation(dealAnimation(for: card, total: 3)) { game.deal()}
                }
            }
        }
    }
    
    
    /// Provides a z-index relative to cards index in model.
    /// Used for dealing animation
    /// - Parameter card: model card
    /// - Returns: a negative Double of cards index in model
    private func zIndex(of card: SetGameModel.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    /// Provides timed animation delayed for the cards deal animation
    /// - Parameter card: model card
    /// - Returns: linear animation timed with FlipDuration delayed for dealDiuration
    private func flipAnimation(for card: SetGameModel.Card) -> Animation {
        var delay = 0.0
        
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.dealDuration / 12)
        }
        
        delay += CardConstants.dealDuration
        return Animation.linear(duration: CardConstants.cardFlipDuration).delay(delay)
    }
    
    /// Provides a timed animation delayd for each card so cards appear to be dealt consecutively instead of all at once
    /// - Parameters:
    ///   - card: model card
    ///   - total: total number of cards in deal animation (3 or 12)
    /// - Returns: linear animation timed with dealDuration delayed depending on its relativity to the top card
    private func dealAnimation(for card: SetGameModel.Card, total: Double) -> Animation {
        var delay = 0.0
        
        if let index = game.deck.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.dealDuration / total)
        }
        return Animation.linear(duration: CardConstants.dealDuration).delay(delay)
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(game: SetGameViewModel())
    }
}
