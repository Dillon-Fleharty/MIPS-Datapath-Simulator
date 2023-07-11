//
//  Instruction.swift
//  DataSim
//
//  Created by Carson Rau on 3/22/23.
//

import Foundation

protocol MIPSInstruction {
    var name: String { get }
    var usage: String { get }
    var alu: ALU { get }
    var pc: ProgramCounter { get }
    var adder: [Adder]? { get }
    var signExt: [SignExtender]? { get }
}

struct Instruction: MIPSInstruction {
    var alu: ALU
    var pc: ProgramCounter
    var adder: [Adder]?
    var signExt: [SignExtender]?
    
    // Instruction Identification
    let type: MIPSType
    let name: String
    let usage: String
    init(_ data: [String: Any]) {
        name = data["name"] as! String
        usage = data["usage"] as! String
        
        // Import ALU Settings
        alu = .init()
        var inA = ((data["alu"] as! [String:Any])["inA"] as! [String:String])
        alu.inputA = (
            .init(),
            .init(rawValue: inA["obj"]!)!,
            .init(rawValue: inA["src"]!)!)
        let inB = ((data["alu"] as! [String:Any])["inB"] as! [String:String])
        alu.inputB = (
            .init(),
            .init(rawValue: inB["obj"]!)!,
            .init(rawValue: inB["src"]!)!)
        var outA = ((data["alu"] as! [String:Any])["outA"] as! [String:String])
        alu.outputA = (
            .init(),
            .init(rawValue: outA["obj"]!)!,
            .init(rawValue: outA["src"]!)!)
        
        // Import PC Settings
        pc = .init()
        inA = ((data["pc"] as! [String:Any])["inA"] as! [String: String])
        pc.inputA = (
            .init(),
            .init(rawValue: inA["obj"]!)!,
            .init(rawValue: inA["src"]!)!)
        outA = ((data["alu"] as! [String:Any])["outA"] as! [String:String])
        pc.outputA = (
            .init(),
            .init(rawValue: outA["obj"]!)!,
            .init(rawValue: outA["src"]!)!)
        
        // Import Adder Settings
        adder = []
        let adders = data["adders"] as! [[String:[String:String]]]
        for dict in adders {
            let newAdder: Adder = .init()
            newAdder.inputA = (
                .init(),
                .init(rawValue: dict["inA"]!["obj"]!)!,
                .init(rawValue: dict["inA"]!["src"]!)!)
            newAdder.inputB = (
                .init(),
                .init(rawValue: dict["inB"]!["obj"]!)!,
                .init(rawValue: dict["inB"]!["src"]!)!)
            newAdder.outputA = (
                .init(),
                .init(rawValue: dict["outA"]!["obj"]!)!,
                .init(rawValue: dict["outA"]!["src"]!)!)
            adder!.append(newAdder)
        }
        signExt = .init()
        type = .init(rawValue: data["MIPSType"]! as! String)!
    }
}

extension Instruction {
    enum MIPSType: String {
        case iFormat
        case rFormat
        case jFormat
    }
}
