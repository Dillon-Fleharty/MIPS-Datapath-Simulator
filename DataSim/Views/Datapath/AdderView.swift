//
//  AdderView.swift
//  DataSim
//
//  Created by Carson Rau on 4/5/23.
//

import SwiftUI

/// An ALU shape with two output wires. This shape can be altered between a view with untappable lines, or a
/// view with a tappable circles.
struct AdderView: View {
    @Binding private var obj: Adder
    @Binding var curSelection: (UUID, DatapathComponent, DatapathComponent.Connection)?
    
    init(obj: Binding<Adder>,
         curSelection: Binding<(UUID, DatapathComponent, DatapathComponent.Connection)?>) {
        self._obj = obj
        self._curSelection = curSelection
    }
    var body: some View {
        AdderLineView()
    }
}

/// An ALU shape where the body of the logic unit is not tappable and each of the four circles is selectable.
/// - Description: This view is important to provide the functionality for individual wires to be configured
///   within the program.
/// - Note: Should be square
struct AdderCircleView: View {
    
    private let color: Color
    private let secondaryColor: Color
    
    init(color: Color = .black, secondaryColor: Color = .gray) {
        self.color = color
        self.secondaryColor = secondaryColor
    }
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ALUShape()
                    .fill(self.color)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 2,
                           height: proxy.size.height)
                    .position(x: proxy.size.width / 2,
                              y: proxy.size.height / 2)
                // Top left
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 4)
                    .position(x: proxy.size.width / 4,
                              y: proxy.size.height / 5)
                // Bottom left
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 4)
                    .position(x: proxy.size.width / 4,
                              y: proxy.size.height - proxy.size.height / 5)
                // Top right
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 4)
                    .position(x: proxy.size.width - (proxy.size.width / 4),
                              y: proxy.size.height / 2)
            }
        }
    }
}

/// - Note: Should be square
struct AdderLineView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ALUShape()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(true)
                    .frame(width: proxy.size.width / 2,
                           height: proxy.size.height)
                    .position(x: proxy.size.width / 2,
                              y: proxy.size.height / 2)
                // Top left
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width / 8,
                              y: proxy.size.height / 5)
                // Bottom left
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width / 8,
                              y: proxy.size.height - proxy.size.height / 5)
                // Top right
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width - (proxy.size.width / 8),
                              y: proxy.size.height / 2)
            }
        }
    }
}

//struct AdderView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdderView(showLines: true)
//            .frame(width: 200, height: 200)
//            .border(.blue, width: 1)
//    }
//}
