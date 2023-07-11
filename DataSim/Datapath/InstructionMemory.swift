//
//  InstructionMemory.swift
//  DataSim
//
//  Created by Carson Rau on 5/11/23.
//

import Foundation

class InstructionMemory: DatapathElement, ObservableObject {
    func setSelection(_ sel: (UUID, DatapathComponent, DatapathComponent.Connection)?) {
        guard let selectedConnection = selectedConnection, let sel = sel else { return }
        switch selectedConnection {
        case .inA:
            inputA = sel
        case .outA:
            outputA = sel
        case .outB:
            outputB = sel
        case .outC:
            outputC = sel
        case .outD:
            outputD = sel
        default: return
        }
    }
    
    func getSelection() -> (UUID, DatapathComponent, DatapathComponent.Connection)? {
        guard let selectedConnection = selectedConnection else { return nil }
        switch selectedConnection {
        case .inA:  return inputA
        case .outA: return outputA
        case .outB: return outputB
        case .outC: return outputC
        case .outD: return outputC
        default:    return nil
        }
    }
    
    
    static func == (lhs: InstructionMemory, rhs: InstructionMemory) -> Bool {
        if lhs.inputA.isNone && lhs.outputA.isNone && lhs.outputB.isNone && lhs.outputC.isNone && lhs.outputD.isNone,
           rhs.inputA.isNone && rhs.outputA.isNone && rhs.outputB.isNone && rhs.outputC.isNone && rhs.outputD.isNone { return true }
        if lhs.inputA?.1 != rhs.inputA?.1 || lhs.inputA?.2 == rhs.inputA?.2 { return false }
        if lhs.outputA?.1 != rhs.outputA?.1 || lhs.outputA?.2 == rhs.outputA?.2 { return false }
        if lhs.outputB?.1 != rhs.outputB?.1 || lhs.outputB?.2 == rhs.outputB?.2 { return false }
        if lhs.outputC?.1 != rhs.outputC?.1 || lhs.outputC?.2 == rhs.outputC?.2 { return false }
        if lhs.outputD?.1 != rhs.outputD?.1 || lhs.outputD?.2 == rhs.outputD?.2 { return false }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = .init()
    
    let componentType: DatapathComponent = .instMem
    
    @Published var inputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputB: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputC: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputD: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var selectedConnection: DatapathComponent.Connection? = nil
}

