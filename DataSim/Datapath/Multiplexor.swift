//
//  Multiplexor.swift
//  DataSim
//
//  Created by Carson Rau on 5/11/23.
//

import Foundation

class Multiplexor: DatapathElement, ObservableObject {
    func setSelection(_ sel: (UUID, DatapathComponent, DatapathComponent.Connection)?) {
        guard let selectedConnection = selectedConnection, let sel = sel else { return }
        switch selectedConnection {
        case .inA:
            inputA = sel
        case .outA:
            outputA = sel
        default: return
        }
    }
    
    func getSelection() -> (UUID, DatapathComponent, DatapathComponent.Connection)? {
        guard let selectedConnection = selectedConnection else { return nil }
        switch selectedConnection {
        case .inA:  return inputA
        case .outA: return outputA
        default:    return nil
        }
    }
    
    
    static func == (lhs: Multiplexor, rhs: Multiplexor) -> Bool {
        if lhs.inputA.isNone && lhs.outputA.isNone,
           rhs.inputA.isNone && rhs.outputA.isNone { return true }
        if lhs.inputA?.1 != rhs.inputA?.1 || lhs.inputA?.2 == rhs.inputA?.2 { return false }
        if lhs.outputA?.1 != rhs.outputA?.1 || lhs.outputA?.2 == rhs.outputA?.2 { return false }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = .init()
    
    let componentType: DatapathComponent = .mux
    
    @Published var inputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var selectedConnection: DatapathComponent.Connection? = nil
}
