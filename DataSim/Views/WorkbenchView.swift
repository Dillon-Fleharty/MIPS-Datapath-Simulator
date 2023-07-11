//
//  WorkbenchView.swift
//  DataSim
//
//  Created by Carson Rau on 4/3/23.
//

import SwiftUI
import NovaCore

struct WorkbenchView: View {
    /// An environment variable to enable escaping from this view.
    @Environment(\.dismiss) private var dismissal
    /// The vertical size class (determining iPad from iPhone) for certain space-sensitive geometries.
    @Environment(\.verticalSizeClass) private var vClass
    
    /// The environment-wide processor.
    @EnvironmentObject var proc: MIPSProcessor
    @EnvironmentObject var manager: GameManager
    @EnvironmentObject var settings: GameSettings
    
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// Which element is currently selected within the workbench.
    ///
    /// - Note: Due to the way the @State wrapper works with tuples, the updates will only occur when
    /// changing this tuple as a whole from nil to a value or vice versa. Updating individual components will
    /// not cause changes in the UI.
    @State private var selectedElement: (UUID, DatapathComponent, DatapathComponent.Connection)? = nil
    @State private var selectedQuit: Bool = false
    @State private var isOver: Bool = false
    @State private var didWin: Bool  = false
    @State private var timerColor: Color = .primary
    
    @State private var viewPositions: [UUID: CGSize] = [:]
    
    
    // TODO: - Scaling & Panning
    
    var topBar: some View {
        GeometryReader { geo in
            HStack(alignment: .center) {
                Group {
                    // Pause Button
                    Button {
                        dismissal()
                        manager.isPaused.toggle()
                    } label: {
                        Image(systemName: "pause.fill")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                    .position(
                        x: 2 * geo.size.height / 30,
                        y: geo.size.width / 30
                    )
                    
                    // Quit Button
                    Button {
                        selectedQuit = true
                    } label: {
                        Image(systemName: "stop.fill")
                            .foregroundColor(.primary)
                            .imageScale(.large)
                    }
                    .position(
                        x: geo.size.height / 30,
                        y: geo.size.width / 30
                    )
                    .fullScreenCover(isPresented: $selectedQuit) {
                        QuitPopup(onQuit: {
                            quitGame()
                        }, onCancel: {
                            selectedQuit = false
                        })
                    }
                    
                    .fullScreenCover(isPresented: $isOver) {
                        GameOverPopup(didWin: didWin) { quitGame() }
                    }
                    
                }
                Spacer()
                if settings.enableTimer {
                    Text("Time Remaining: \(formattedTime(manager.timeRemaining))")
                        .padding([.top], 15)
                        .foregroundColor(timerColor)
                        .font(.customSubtitle)
                        .onReceive(timer) { _ in
                            if !manager.isPaused && manager.timeRemaining > 0 {
                                manager.timeRemaining -= 1
                            } else {
                                timer.upstream.connect().cancel()
                            }
                        }
                        .onReceive(timer) { _ in
                            if settings.enableTimer && settings.enableHaptics && manager.timeRemaining == 601 {
                                Haptic.play([
                                    .haptic(.impact(.soft)),
                                    .wait(0.5),
                                    .haptic(.impact(.soft))
                                ])
                            }
                            if settings.enableTimer && settings.enableHaptics && manager.timeRemaining == 301 {
                                Haptic.play([
                                    .haptic(.impact(.medium)),
                                    .wait(0.5),
                                    .haptic(.impact(.medium))
                                ])
                            }
                            if settings.enableTimer && settings.enableHaptics && manager.timeRemaining == 61 {
                                Haptic.play([
                                    .haptic(.impact(.heavy)),
                                    .wait(0.5),
                                    .haptic(.impact(.heavy))
                                ])
                                timerColor = .red
                            }
                            if settings.enableTimer && settings.enableHaptics && manager.timeRemaining == 31 {
                                Haptic.play([
                                    .haptic(.impact(.rigid)),
                                    .wait(0.5),
                                    .haptic(.impact(.rigid))
                                ])
                            }
                            if settings.enableTimer && settings.enableHaptics && manager.timeRemaining < 10 {
                                Haptic.play([.haptic(.impact(.heavy))])
                            }
                            if settings.enableTimer && manager.timeRemaining == 0 {
                                gameOver()
                            }
                        }
                }
            }
        }
        .onAppear {
            if !settings.enableTimer {
                timer.upstream.connect().cancel()
            }
        }
    }
    
    /// The horizontal pane containing the datapath units available for use on the workbench.
    var selectionPane: some View {
        HStack {
            ForEach(DatapathComponent.allCases,
                    id: \.self) { comp in
                VStack {
                    DatapathElementPreviewView(comp)
                    // Add a new instance of the proper datapath unit on tap.
                        .onTapGesture {
                            switch comp {
                            case .alu:
                                proc.alus.append(.init())
                            case .adder:
                                proc.adders.append(.init())
                            default:
                                return
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                    Text(comp.rawValue)
                        .font(.customSubtitle)
                }
            }
            Divider()
            // TODO: Logical units after the Divider.
            Spacer()
        }
    }
    
    /// The collection of ALUs visible on the workbench.
    var alus: some View {
        GeometryReader { geo in
            ForEach($proc.alus, id: \.self) { $alu in
                ALUView(obj: $alu, curSelection: $selectedElement)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .position(x: 30, y: 30)
            }
        }
    }
    
    /// The collection of ALUs visible on the workbench.
    var adders: some View {
        GeometryReader { geo in
            ForEach($proc.adders, id: \.self) { $adder in
                AdderView(obj: $adder, curSelection: $selectedElement)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)
                    .position(x: -50, y: -50)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                topBar
                    .frame(height: (vClass == .compact) ? geo.size.height / 10 : geo.size.height / 20)
                    .padding()
                ScrollView([.horizontal, .vertical],
                           showsIndicators: false) {
                    alus
                    adders
                }
                           .onTapGesture {
                               if selectedElement != nil {
                                   switch selectedElement!.1 {
                                   case .alu:
                                       proc.alus.first {
                                           $0.id == selectedElement!.0
                                       }?.selectedConnection = nil
                                   default:
                                       return
                                   }
                                   selectedElement = nil
                               }
                           }
                Divider()
                ScrollView([.horizontal], showsIndicators: false) {
                    selectionPane
                }
                .padding(.horizontal, 5.0)
                .frame(maxHeight: (vClass == .compact) ?
                       geo.size.height / 5 : geo.size.height / 10)
            }
        }
    }
    
    func formattedTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    func quitGame() {
        dismissal()
        manager.reset(settings.getTimeRemaining())
        proc.reset()
    }
    func gameOver() {
        Haptic.play("XXOOXXOOXX", delay: 0.2)
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            self.timerColor = [.red, .yellow, .primary].randomElement() ?? .primary
           }
        // Call the grader
        didWin = manager.grade(proc)
        isOver = true
    }
}

struct GameOverPopup: View {
    @Environment(\.colorScheme) var colorScheme
    let didWin: Bool
    let onQuit: () -> Void

    var body: some View {
        ZStack {
            VStack {
                Text(didWin ? "Congratulations!" : "Good luck next time")
                    .foregroundColor(.primary)
                    .font(.customBody)
                    .padding()

                Text("You will return to the main menu.")
                    .foregroundColor(.primary)
                    .font(.customSubtitle)
                    .padding()

                Button(action: onQuit) {
                    Text("Quit")
                        .font(.customCaption)
                        .padding()
                        .foregroundColor(.primary)
                        .background(Color.red)
                        .cornerRadius(10)
                }
            }
            .frame(width: 300, height: 200)
            .background(colorScheme == .light ? Color.white : Color.black)
            .cornerRadius(20)
        }
    }
}


struct QuitPopup: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let onQuit: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        ZStack {
            VStack {
                Text("Do you wish to quit?")
                    .foregroundColor(.primary)
                    .font(.customBody)
                    .padding()
                
                Text("You will return to the main menu.")
                    .foregroundColor(.primary)
                    .font(.customSubtitle)
                    .padding()
                
                HStack {
                    Button(action: onQuit) {
                        Text("Quit")
                            .font(.customCaption)
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    Button(action: onCancel) {
                        Text("Cancel")
                            .font(.customCaption)
                            .padding()
                            .foregroundColor(.primary)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .frame(width: 300, height: 200)
            .background(colorScheme == .light ? Color.white : Color.black)
            .cornerRadius(20)
        }
    }
}
