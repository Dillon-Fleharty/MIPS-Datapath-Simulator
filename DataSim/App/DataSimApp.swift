//
//  DataSimApp.swift
//  DataSim
//
//  Created by Carson Rau on 3/20/23.
//

import SwiftUI

@main
struct DataSimApp: App {
    /// The single source of truth for the processor modelled by the active datapath.
    @StateObject private var processor: MIPSProcessor = .init()
    @StateObject private var appSettings: GameSettings = .init()
    @StateObject private var gameManager: GameManager = .init()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(processor)
                .environmentObject(appSettings)
                .environmentObject(gameManager)
        }
    }
}
