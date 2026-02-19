//
//  FlyingNumber.swift
//  Memorize
//
//  Created by KC Thomas on 12/31/25.
//

import SwiftUI

struct FlyingNumber: View {
    var number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if (number != 0) {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .foregroundColor(number < 0 ? .red : .green)
                .shadow(color: .black, radius: 1.5, x: 1, y: 1)
                .offset(x: 0, y: offset)
                .opacity(offset == 0 ? 1 : 0)
                .onAppear {
                    withAnimation(.easeOut(duration: 2.8)) {
                        offset = number < 0 ? 200 : -200
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
}
