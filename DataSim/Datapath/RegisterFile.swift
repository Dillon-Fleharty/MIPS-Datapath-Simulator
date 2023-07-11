//
//  RegisterFile.swift
//  DataSim
//
//  Created by Carson Rau on 5/11/23.
//

import Foundation

class RegisterFile: DatapathElement, ObservableObject {
    func setSelection(_ sel: (UUID, DatapathComponent, DatapathComponent.Connection)?) {
        guard let selectedConnection = selectedConnection, let sel = sel else { return }
        switch selectedConnection {
        case .inA:
            inputA = sel
        case .inB:
            inputB = sel
        case .inC:
            inputC = sel
        case .inD:
            inputD = sel
        case .outA:
            outputA = sel
        case .outB:
            outputB = sel
        default: return
        }
    }
    
    func getSelection() -> (UUID, DatapathComponent, DatapathComponent.Connection)? {
        guard let selectedConnection = selectedConnection else { return nil }
        switch selectedConnection {
        case .inA:  return inputA
        case .inB:  return inputB
        case .inC:  return inputC
        case .inD:  return inputD
        case .outA: return outputA
        case .outB: return outputB
        default:    return nil
        }
    }
    
    
    static func == (lhs: RegisterFile, rhs: RegisterFile) -> Bool {
        if lhs.inputA.isNone && lhs.inputB.isNone && lhs.inputC.isNone && lhs.inputD.isNone && lhs.outputA.isNone && lhs.outputB.isNone,
           rhs.inputA.isNone && rhs.inputB.isNone && rhs.inputC.isNone && rhs.inputD.isNone && rhs.outputA.isNone && rhs.outputB.isNone { return true }
        if lhs.inputA?.1 != rhs.inputA?.1 || lhs.inputA?.2 == rhs.inputA?.2 { return false }
        if lhs.inputB?.1 != rhs.inputB?.1 || lhs.inputB?.2 == rhs.inputB?.2 { return false }
        if lhs.inputC?.1 != rhs.inputC?.1 || lhs.inputC?.2 == rhs.inputC?.2 { return false }
        if lhs.inputD?.1 != rhs.inputD?.1 || lhs.inputD?.2 == rhs.inputD?.2 { return false }
        if lhs.outputA?.1 != rhs.outputA?.1 || lhs.outputA?.2 == rhs.outputA?.2 { return false }
        if lhs.outputB?.1 != rhs.outputB?.1 || lhs.outputB?.2 == rhs.outputB?.2 { return false }
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: UUID = .init()
    
    let componentType: DatapathComponent = .regfile
    
    @Published var inputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var inputB: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var inputC: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var inputD: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputA: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var outputB: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @Published var selectedConnection: DatapathComponent.Connection? = nil
}
