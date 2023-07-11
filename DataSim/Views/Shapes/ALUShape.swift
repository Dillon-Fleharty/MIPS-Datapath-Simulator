//
//  ALUShape.swift
//  DataSim
//
//  Created by Carson Rau on 3/20/23.
//

import SwiftUI

/// Ideal: 100 x 200 (1 : 2)
struct ALUShape: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: .init(x: rect.minX, y: rect.minY))
        path.addLine(to: .init(x: rect.minX, y: rect.height / 2.5))
        path.addLine(to: .init(x: rect.width / 6, y: rect.height / 2))
        path.addLine(to: .init(x: rect.minX, y: rect.height - (rect.height / 2.5)))
        path.addLine(to: .init(x: rect.minX, y: rect.maxY))
        path.addLine(to: .init(x: rect.maxX, y: (rect.height / 4) * 3))
        path.addLine(to: .init(x: rect.maxX, y: rect.height / 4))
        path.addLine(to: .init(x: rect.minX, y: rect.minY))
        return path
    }
}

struct ALUShapeView: View {
    var body: some View {
        ALUShape()
    }
}

struct ALUShape_Previews: PreviewProvider {
    static var previews: some View {
        ALUShapeView()
            .frame(width: 100, height: 200)
    }
}
