//
//  MIPSProcessor.swift
//  DataSim
//
//  Created by Carson Rau on 4/8/23.
//

import Foundation

class MIPSProcessor: ObservableObject {
    @Published var alus: [ALU] = []
    @Published var adders: [Adder] = []
    @Published var pc: ProgramCounter? = nil
    @Published var signExtenders: [SignExtender] = []
    @Published var muxes: [Multiplexor] = []
    @Published var regFile: RegisterFile? = nil
    @Published var instructionMem: InstructionMemory? = nil
    @Published var dataMem: DataMemory? = nil
    @Published var shifters: [Shifter] = []
    
    func reset() {
        alus.removeAll()
        adders.removeAll()
        pc = nil
        signExtenders.removeAll()
        muxes.removeAll()
        regFile = nil
        instructionMem = nil
        dataMem = nil
        shifters.removeAll()
    }
}
