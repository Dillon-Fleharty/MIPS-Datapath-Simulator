//
//  OptionsView.swift
//  DataSim
//
//  Created by Carson Rau on 4/3/23.
//

import SwiftUI

struct OptionsView: View {
    @EnvironmentObject private var settings: GameSettings
    @EnvironmentObject private var gameManager: GameManager
    
    var timerSettings: some View {
        VStack {
            HStack {
                Spacer()
                Picker(selection: $settings.difficulty) {
                    Text(GameSettings.Difficulty.turtle.rawValue).tag(GameSettings.Difficulty.turtle)
                        .font(.customCaption)
                    Text(GameSettings.Difficulty.easy.rawValue).tag(GameSettings.Difficulty.easy)
                        .font(.customCaption)
                    Text(GameSettings.Difficulty.medium.rawValue).tag(GameSettings.Difficulty.medium)
                        .font(.customCaption)
                    Text(GameSettings.Difficulty.hard.rawValue).tag(GameSettings.Difficulty.hard)
                        .font(.customCaption)
                    Text(GameSettings.Difficulty.lightning.rawValue).tag(GameSettings.Difficulty.lightning)
                        .font(.customCaption)
                    Text(GameSettings.Difficulty.demo.rawValue).tag(GameSettings.Difficulty.demo)
                        .font(.customCaption)
                } label: {
                    Text("Timer Difficult Selection")
                        .font(.customBody)
                }
                .onChange(of: settings.difficulty) { newValue in
                    gameManager.timeRemaining = settings.getTimeRemaining()
                }
                .pickerStyle(.inline)
                Spacer()
            }
            VStack {
                HStack {
                    Spacer()
                    Toggle(isOn: $settings.enableHardMode) {
                        Text("Hard Mode")
                            .font(.customBody)
                    }
                        .onChange(of: settings.enableHardMode) { newValue in
                            if (!settings.enableTimer) {
                                settings.enableHardMode = false
                            }
                        }
                        .fixedSize()
                    Spacer()
                }
                Text("Hardmode reduces time remaining on each incorrect connection.")
                    .font(.customSubtitle)
                    .foregroundColor(.gray)
            }
            
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("App Settings")
                    .font(.customLargeTitle)
                Spacer()
            }
            .animation(.default)
            if gameManager.isPaused {
                Text("If you want to make changes to the timer settings, you must first quit your current game!")
                    .multilineTextAlignment(.center)
                    .font(.customBody)
                    .padding([.top, .bottom], 30)
                    .animation(.default)
            } else {
                HStack {
                    Spacer()
                    Toggle(isOn: $settings.enableTimer) {
                        Text("Use Timer")
                            .font(.customBody)
                    }
                        .onChange(of: settings.enableTimer) { newValue in
                            if (newValue == false && settings.enableHardMode) {
                                settings.enableHardMode = false
                            }
                        }
                        .fixedSize()
                    Spacer()
                }
                .animation(.default)
                if settings.enableTimer {
                    timerSettings
                        .transition(.slide)
                        .animation(.default)
                }
            }
            HStack {
                Spacer()
                ColorPicker(selection: $settings.primaryColor) {
                    Text("Datapath Element Color")
                        .font(.customBody)
                }
                    .fixedSize()
                Spacer()
            }
            .animation(.default)
            HStack {
                Toggle(isOn: $settings.enableHaptics) {
                    Text("Enable Haptics")
                        .font(.customBody)
                }
                    .fixedSize()
            }
            .animation(.default)
            Spacer()
        }
    }
}
