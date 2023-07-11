//
//  ShakeEffect.swift
//  DataSim
//
//  Created by Carson Rau on 4/8/23.
//

import SwiftUI


struct ShakeEffect: GeometryEffect {
    var animatableData: CGFloat
    
    func modifier(_ x: CGFloat) -> CGFloat {
        10 * sin(x * .pi * 2)
    }
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 10 + modifier(animatableData), y: 0))
    }
}

