//
//  Adder.swift
//  DataSim
//
//  Created by Carson Rau on 4/6/23.
//

import Foundation

class Adder: DatapathElement, ObservableObject {
    func setSelection(_ sel: (UUID, DatapathComponent, DatapathComponent.Connection)?) {
        guard let selectedConnection = selectedConnection, let sel = sel else { return }
        switch selectedConnection {
        case .inA:
            inputA = sel
        case .inB:
            inputB = sel
        case .outA:
            outputA = sel
        default: return
        }
    }
    
    func getSelection() -> (UUID, DatapathComponent, DatapathComponent.Connection)? {
        guard let selectedConnection = selectedConnection else { return nil }
        switch selectedConnection {
        case .inA:  return inputA
        case .inB:  return inputB
        case .outA: return outputA
        default:    return nil
        }
    }
    
    
    static func == (lhs: Adder, rhs: Adder) -> Bool {
        if lhs.inputA.isNone && lhs.inputB.isNone && lhs.outputA.isNone,
           rhs.inputA.isNone && rhs.inputB.isNone && rhs.outputA.isNone { return true }
        if lhs.inputA?.1 != rhs.inputA?.1 || lhs.inputA?.2 == rhs.inputA?.2 { return false }
        if lhs.inputB?.1 != rhs.inputB?.1 || lhs.inputB?.2 == rhs.inputB?.2 { return false }
        if lhs.outputA?.1 != rhs.outputA?.1 || lhs.outputA?.2 == rhs.outputA?.2 { return false }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = .init()
    
    let componentType: DatapathComponent = .adder
    
    @Published var inputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var inputB: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var selectedConnection: DatapathComponent.Connection? = nil
}
