//
//  DatapathElement.swift
//  DataSim
//
//  Created by Carson Rau on 4/5/23.
//

import Foundation

/// An enumeration containing all datapath component types supported by this application.
public enum DatapathComponent: String, CaseIterable, Equatable, Hashable {
    case adder      = "Adder",
         alu        = "ALU",
         mux        = "Mux",
         signExt    = "Sign Ext",
         pc         = "PC",
         regfile    = "Reg File",
         instMem    = "IM",
         dataMem    = "DM",
         shifter    = "Shifter"
}

extension DatapathComponent {
    public enum Connection: String {
        case inA, inB, inC, inD
        case outA, outB, outC, outD
    }
}

protocol DatapathElement: Hashable, Equatable, Identifiable {
    var id: UUID { get }
    var componentType: DatapathComponent { get }
    var selectedConnection: DatapathComponent.Connection? { get }
    
    func getSelection() -> (UUID, DatapathComponent, DatapathComponent.Connection)?
    func setSelection(_ sel: (UUID, DatapathComponent, DatapathComponent.Connection)?)
}

extension DatapathElement {
    var shortName: String { self.componentType.rawValue }
    var fullName: String {
        switch componentType {
        case .adder:
            return "Adder"
        case .alu:
            return "Arithmetic Logic Unit"
        case .mux:
            return "Multiplexor"
        case .signExt:
            return "Sign Extension Unit"
        case .pc:
            return "Program Counter"
        case .regfile:
            return "Register File"
        case .instMem:
            return "Instruction Memory"
        case .dataMem:
            return "Data Memory"
        case .shifter:
            return "Shifter"
        }
    }
}
