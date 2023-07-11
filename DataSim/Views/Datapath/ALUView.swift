//
//  ALUView.swift
//  DataSim
//
//  Created by Carson Rau on 3/22/23.
//

import SwiftUI
import NovaCore

/// An ALU shape with two output wires. This shape can be altered between a view with untappable lines, or a
/// view with a tappable circles.
struct ALUView: View {
    
    @EnvironmentObject var settings: GameSettings
    @EnvironmentObject var manager: GameManager
    /// The shaking variable to control the rejection animation for improper actions.
    @State private var shaking: Bool = false
    /// The model representing the ALU presented in this view.
    @Binding private var obj: ALU
    /// The current selection within the workbench view that contains this ALU.
    ///
    /// This binding is necessary to allow completion of connections within the hit-regions of this view.
    @Binding var curSelection: (UUID, DatapathComponent, DatapathComponent.Connection)?
    
    /// The Environment-wide processor containing data regarding datapath elements on the workbench.
    @EnvironmentObject private var proc: MIPSProcessor
    
    /// Make a new view of this type by providing bindings to previously created state objects.
    init(obj: Binding<ALU>,
         curSelection: Binding<(UUID, DatapathComponent, DatapathComponent.Connection)?>
    ) {
        _obj = obj
        _curSelection = curSelection
    }
    
    /// The hit-testing regions of this view.
    var hitCircles: some View {
        GeometryReader { geo in
            ZStack {
                // Top left [InputA]
                Circle()
                    .fill(.background)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 4, height: geo.size.height / 4)
                    .position(x: geo.size.width / 4, y: geo.size.height / 5)
                    .onTapGesture {
                        // Ensure an output has previously been selected for this input.
                        // Ensure this input is open for a connection.
                        guard let curSelection = curSelection, obj.inputA.isNone else {
                            handleWrongTap()
                            return
                        }
                        // Determine what output was currently selected.
                        switch curSelection.1 {
                        case .alu:
                            let src = proc.alus.first { $0.id == curSelection.0 }!
                            // Map the currently selected output to the newly selected input.
                            src.setSelection((obj.id, .alu, .inA))
                            // Map the newly selected input to the currently selected output.
                            obj.inputA = (src.id, .alu, src.selectedConnection!)
                            // Empty the selected connection.
                            self.curSelection = nil
                        default:
                            return
                        }
                    }
                // Bottom left [InputB]
                Circle()
                    .fill(.background)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 4, height: geo.size.height / 4)
                    .position(x: geo.size.width / 4, y: geo.size.height - geo.size.height / 5)
                    .onTapGesture {
                        guard let curSelection = curSelection, obj.inputB.isNone else {
                            handleWrongTap()
                            return
                        }
                        switch curSelection.1 {
                        case .alu:
                            let src = proc.alus.first { $0.id == curSelection.0 }!
                            src.setSelection((obj.id, .alu, .inB))
                            obj.inputB = (src.id, .alu, src.selectedConnection!)
                            self.curSelection = nil
                        default:
                            return
                        }
                        
                    }
                // Top right [OutputA]
                Circle()
                    .fill(.background)
                    .opacity(0.1)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 4,
                           height: geo.size.height / 4)
                    .position(x: geo.size.width - (geo.size.width / 4),
                              y: (geo.size.height / 8) * 3)
                    .onTapGesture {
                        // Ensure there is no selection previous. (outputs come first).
                        guard curSelection == nil else {
                            // If this output is already selected, we interpret this as a desire to deselect.
                            if curSelection!.0 == obj.id && curSelection!.1 == .alu && curSelection!.2 == .outA {
                                curSelection = nil
                                obj.selectedConnection = nil
                                return
                            }
                            handleWrongTap()
                            return
                        }
                        // Ensure this connection is available.
                        guard obj.outputA.isNone else {
                            handleWrongTap()
                            return
                        }
                        // Select outputA on the object level for injection with setSelected()
                        obj.selectedConnection = .outA
                        // Mark this as the currently selected object on the workspace level
                        curSelection = (obj.id, .alu, .outA)
                        
                    }

                // Bottom right
                Circle()
                    .fill(.background)
                    .opacity(0.1)
                    .allowsHitTesting(true)
                    .frame(width: geo.size.width / 4,
                           height: geo.size.height / 4)
                    .position(x: geo.size.width - (geo.size.width / 4),
                              y: (geo.size.height / 8) * 5)
                    .onTapGesture {
                        guard curSelection == nil else {
                            if curSelection!.0 == obj.id && curSelection!.1 == .alu && curSelection!.2 == .outB {
                                curSelection = nil
                                obj.selectedConnection = nil
                                return
                            }
                            handleWrongTap()
                            return
                        }
                        guard obj.outputB.isNone else {
                            handleWrongTap()
                            return
                        }
                        obj.selectedConnection = .outB
                        curSelection = (obj.id, .alu, .outB)
                    }
            }
        }
    }
    
    /// The wire-components visible within the bounds of this view if/when connections are made.
    var wires: some View {
        GeometryReader { geo in
            // Visual wires within the bounds of this view
            // Top left
            Rectangle()
                .fill(settings.primaryColor)
                // Only show lines if: (1) this line is part of a completed path || (2) this is the current selection
                .opacity((obj.inputA != nil || obj.selectedConnection == .inA) ? 100 : 0)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 4,
                       height: geo.size.height / 40)
                .position(x: geo.size.width / 8,
                          y: geo.size.height / 5)
            // Bottom left
            Rectangle()
                .fill(settings.primaryColor)
                .opacity((obj.inputB != nil || obj.selectedConnection == .inB) ? 100 : 0)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 4,
                       height: geo.size.height / 40)
                .position(x: geo.size.width / 8,
                          y: geo.size.height - geo.size.height / 5)
            // Top right
            Rectangle()
                .fill(settings.primaryColor)
                .opacity((obj.outputA != nil || obj.selectedConnection == .outA) ? 100 : 0)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 4,
                       height: geo.size.height / 40)
                .position(x: geo.size.width - (geo.size.width / 8),
                          y: (geo.size.height / 8) * 3)
            // Bottom right
            Rectangle()
                .fill(settings.primaryColor)
                .opacity((obj.outputB != nil || obj.selectedConnection == .outB) ? 100 : 0)
                .allowsHitTesting(false)
                .frame(width: geo.size.width / 4,
                       height: geo.size.height / 40)
                .position(x: geo.size.width - (geo.size.width / 8),
                          y: (geo.size.height / 8) * 5)
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                hitCircles
                ALUShape()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: geo.size.width / 2,
                           height: geo.size.height)
                    .position(x: geo.size.width / 2,
                              y: geo.size.height / 2)
                wires
            }
            .modifier(ShakeEffect(animatableData: .init(self.shaking ? 1 : 0)))
            .animation(Animation.linear(duration: 0.3), value: shaking)
        }
    }
    
    func handleWrongTap() {
        shaking.toggle()
        if settings.enableTimer && settings.enableHardMode {
            manager.timeRemaining -= 5
        }
    }
}

/// A preview of this datapath component containing static wires.
/// - Note: Should be square
struct ALULineView: View {
    @EnvironmentObject var settings: GameSettings
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ALUShape()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(true)
                    .frame(width: proxy.size.width / 2,
                           height: proxy.size.height)
                    .position(x: proxy.size.width / 2,
                              y: proxy.size.height / 2)
                // Top left
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width / 8,
                              y: proxy.size.height / 5)
                // Bottom left
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width / 8,
                              y: proxy.size.height - proxy.size.height / 5)
                // Top right
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width - (proxy.size.width / 8),
                              y: (proxy.size.height / 8) * 3)
                // Bottom right
                Rectangle()
                    .fill(settings.primaryColor)
                    .allowsHitTesting(false)
                    .frame(width: proxy.size.width / 4,
                           height: proxy.size.height / 40)
                    .position(x: proxy.size.width - (proxy.size.width / 8),
                              y: (proxy.size.height / 8) * 5)
            }
        }
    }
}
