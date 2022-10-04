//
//  AspectCard.swift
//  Set
//
//  Created by Andrew Shields on 10/2/22.
//

import SwiftUI

struct AspectCard<T>:View where T: View {
    var aspectRatio: CGFloat
    var padding: CGFloat?
    var content: () -> T
    
    init(aspectRatio: CGFloat, padding: CGFloat? = nil, @ViewBuilder content: @escaping () -> T) {
        self.aspectRatio = aspectRatio
        self.padding = padding
        self.content = content
    }
    
    var body: some View {
        content()
            .aspectRatio(aspectRatio, contentMode: .fit)
            .padding(.all, padding)
    }
}
