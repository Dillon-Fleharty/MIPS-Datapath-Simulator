//
//  MuxView.swift
//  DataSim
//
//  Created by Carson Rau on 4/5/23.
//

import SwiftUI

// A half-size datapath element: the mux. Should still be square.
struct MuxView: View {
    private let hasLines: Bool
    private let color: Color
    private let secondaryColor: Color
    init(showLines: Bool = true,
         color: Color = .black,
         secondaryColor: Color = .gray) {
        self.hasLines = showLines
        self.color = color
        self.secondaryColor = secondaryColor
    }
    var body: some View {
        if hasLines {
            MuxLineView()
        } else {
            MuxCircleView(color: self.color, secondaryColor: self.secondaryColor)
        }
    }
}

struct MuxCircleView: View {
    private let color: Color
    private let secondaryColor: Color
    init(color: Color = .black, secondaryColor: Color = .gray) {
        self.color = color
        self.secondaryColor = secondaryColor
    }
    var body: some View {
        GeometryReader { geo in
            GeometryReader { geo in
                Capsule(style: .continuous)
                    .fill(self.color)
                    .allowsHitTesting(false)
                    .frame(width: geo.size.width / 4)
                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                // Top left
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: geo.size.width / 4, y: geo.size.height / 4)
                // Bottom Left
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 2,
                           height: geo.size.height / 2)
                    .position(x: geo.size.width / 4,
                              y: geo.size.width - (geo.size.width / 4))
                Circle()
                    .fill(self.secondaryColor)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 2, height: geo.size.height / 2)
                    .position(x: geo.size.width / 4 * 3, y: geo.size.height / 2)
            }
        }
    }
}

struct MuxLineView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        GeometryReader { geo in
            Capsule(style: .continuous)
                .fill(settings.primaryColor)
                .allowsHitTesting(true)
                .frame(width: geo.size.width / 4)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
            // Top left
            Rectangle()
                .fill(settings.primaryColor)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 2, height: geo.size.height / 40)
                .position(x: geo.size.width / 4, y: geo.size.height / 4)
            // Bottom Left
            Rectangle()
                .fill(settings.primaryColor)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 2,
                       height: geo.size.height / 40)
                .position(x: geo.size.width / 4,
                          y: geo.size.width - (geo.size.width / 4))
            Rectangle()
                .fill(settings.primaryColor)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 2, height: geo.size.height / 40)
                .position(x: geo.size.width / 4 * 3, y: geo.size.height / 2)
        }
    }
}

struct MuxView_Previews: PreviewProvider {
    static var previews: some View {
        MuxView()
            .frame(width: 100, height: 100)
//            .border(.blue, width: 1)
    }
}
