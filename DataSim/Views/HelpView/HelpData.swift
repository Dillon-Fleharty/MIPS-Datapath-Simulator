//
//  HelpData.swift
//  DataSim
//
//  Created by Carson Rau on 5/11/23.
//

import Foundation

protocol HelpInfo {
    var action: String { get }
    var inputs: String { get }
    var outputs: String { get }
    var uses: [String] { get }
}

struct HelpData {
    static let info: [DatapathComponent: HelpInfo] = [
        .alu: HelpData.ALU(),
        .regfile: HelpData.RegFile(),
        .mux: HelpData.Mux(),
        .adder: HelpData.Adder(),
        .signExt: HelpData.SignExtension(),
        .shifter: HelpData.Shifter(),
        .pc: HelpData.ProgramCounter(),
        .instMem: HelpData.InstructionMemory(),
        .dataMem: HelpData.DataMemory()
    ]
    struct ALU: HelpInfo {
        let action: String =
            "The Arithmetic Logic Unit (or ALU) is a datapath element within the processor that"
          + "is responsible for computing logical and arithmetic operations on the data it receives."
        let inputs: String =
            "The ALU receives two inputs. These typically come from the register file, but special "
          + "instruction types, like branches, use a portion of the instruction as an input to the ALU."
        let outputs: String =
            "The ALU has two outputs, the top output is the primary output for this logic unit, and the "
          + "secondary output is an optional \"zero\" value used as a control signal for certain instructions."
        let uses: [String] = [
            "Arithmetic operations (eg. addition, subtraction, multiplication, and division) on integer operands.",
            "Logical operations (eg. and, or, xor, nand)",
            "Comparing values for equality (eg. beq)"
        ]
    }
    struct RegFile: HelpInfo {
        let action: String =
            "A Register File is a collection of short-term, quick access storage locations of 32-bits in size "
          + "that are used to store immediate data values or operands during operations. These are the fastest "
          + "kind of memory within the computer."
        let inputs: String = "The Register File receives a wide variety of connections to support a range of operations. "
          + "the top two inputs are responsible for providing register numbers from which to read data.The third input, write "
          + "register, determines which register will be written (if the control signals not modeled in this application "
          + "dictate). The final input contains the data to be written, which typically comes from the ALU or the Data Memory."
        let outputs: String = "The two outputs from the register file contain the data read from the two registers given as inputs."
        let uses: [String] = [
            "Holding operands and intermediate results during arithmetic/logical operations.",
            "Storing values fetched from memory.",
            "Supporting register-to-register data transfers."
        ]
    }
    
    
    struct Mux: HelpInfo {
        let action: String =
            "A Multiplexor (Mux) connects two outputs to a single input, allowing selection between them with a control signal"
        let inputs: String =
            "There are two inputs given to the mux, from which it can pick."
        let outputs: String = "Of the two given inputs, one is selected to be forwarded."
        let uses: [String] = [
            "Enables switching between different registers for a variety of instructions on the same datapath circuit.",
            "Dynamically allows selection of the program counter's source."
        ]
    }
    
    struct Adder: HelpInfo {
        let action: String = "An adder is a digital circuit to perform addition on binary integers."
        let inputs: String = "The two inputs for an adder will be the binary inputs for addition within the adder."
        let outputs: String = "The output of the binary addition is the sole output of this element."
        let uses: [String] = [
            "The primary use for an adder is for incrementing the memory address for the program counter.",
            "Any case where a static addition is necessary, an adding circuit may be used.",
            "Adders help in the implementation of XOR and other logical operations."
        ]
    }
    
    struct SignExtension: HelpInfo {
        let action: String = "A sign extension unit is a simple datapath element responsible with filling extra binary bits in a "
        + "larger field (eg. a 16 -> 32 bit sign extension unit would fill the high order 16 bits with zeros)."
        let inputs: String = "The single binary value to extend."
        let outputs: String = "The extended value."
        let uses: [String] = [
            "Extension units can be used to facilitate arithmetic of signed numbers.",
            "Sign extension of immediate values and address offsets is a common way of implementing branches and jumps.",
            "Sign extenders validate the correctness of negative numbers in signed binary arithmetic."
        ]
    }
    
    struct Shifter: HelpInfo {
        let action: String = "A shifter is a digital circuit that performs a logical shift in a given direction by the specified "
         + "number of bits. In contrast to a sign extension unit, no bits are added or removed from the shifter, they are recycled "
         + "to the opposite end of the bit field."
        let inputs: String = "The binary data to be shifted is an input. The shift amount for the shifter can also be provided as "
         + " an electrical input; however, in this simulation, the shifter is statically set at left 2."
        let outputs: String = "The result of the shift operation is the output."
        let uses: [String] = [
            "Shifting allows for fast multiplication and division of unsigned binary integers.",
            "Implementing logical operations such as bitwise masking and rotation rely on shift operations.",
            "The shifter is crucial for concatenating the program counter's high bits with the computed address for a branch."
        ]
    }
    
    struct ProgramCounter: HelpInfo {
        let action: String = "The program counter is a special-purpose register within the datapath to store the memory address "
        + "of the next instruction to be fetched and executed."
        let inputs: String = "The program counter takes a single input containing the address of the next instruction."
        let outputs: String = "The output provided, at a slight delay, is the data from the register."
        let uses: [String] = [
            "The Program Counter is responsible for sequencing instructions and enabling top-to-bottom execution of programs.",
            "Specialized modification of the input to the program counter is key to implementation of branching, loops, and other "
            + "control flow structures."
        ]
    }
    
    struct InstructionMemory: HelpInfo {
        let action: String =
            "The instruction memory stores machine instructions to be fetched, decoded, and executed by the processor."
        let inputs: String = "The instruction memory takes a single input containing the address of the instruction to be fetched."
        let outputs: String = "Although technically a single output that is subdivided into various bit streams, we model the "
        + "instruction memory with four distinct outputs: three representing the individual bit fields of the registers, and the "
        + "fourth containing the remainder of the bits of the instruction to be interpreted as an address."
        let uses: [String] = [
            "The separation of instructions from data enables the pipelined architecture that MIPS is known for."
        ]
    }
    
    struct DataMemory: HelpInfo {
        let action: String = "The data memory contains the remainder of memory accessible to the processor."
        let inputs: String = "The data memory accepts two inputs: first, an input to an address from which data can be accessed. "
        + "Second, there is a data input connection to accept data that may need to be written into the data memory."
        let outputs: String = "The data memory provides a single output containing data read from the given memory address."
        let uses: [String] = [
            "Data memory is critical because, by nature of the cost of high speed memory, not all data can remain on the chip. " +
            "Data memory is essential for larger programs and more complex calculations, where data may exceed that which can be " +
            "stored in the 32-bit registers.",
            "Although data memory is larger, it is often slower, and should be used to store data that is accessed less frequently " + " than the data in the registers."
        ]
    }
    
    static func getInfo(for kind: DatapathComponent) -> HelpInfo { info[kind]! }
}
