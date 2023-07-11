//
//  MainView.swift
//  DataSim
//
//  Created by Carson Rau on 3/20/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        GeometryReader { geo in
            NavigationStack {
                Group {
                    Spacer()
                    Text("MIPS DataSim")
                        .foregroundColor(.primary)
                        .font(.customLargeTitle)
                }
                Group {
                    Spacer()
                        .frame(height: 40)
                    NavigationLink(
                        destination: WorkbenchView()
                            .navigationBarBackButtonHidden(true)
                    ) {
                        Text("New Game")
                            .foregroundColor(.primary)
                            .font(.customHeadline)
                            .frame(height: 20)
                    }
                }
                Spacer()
                    .frame(height: 20)
                NavigationLink(destination: HelpView()) {
                    Text("Datapath Hints")
                        .foregroundColor(.primary)
                        .font(.customHeadline)
                        .frame(height: 20)
                }
                Spacer()
                    .frame(height: 20)
                NavigationLink(destination: OptionsView()) {
                    Text("Game Settings")
                        .foregroundColor(.primary)
                        .font(.customHeadline)
                        .frame(height: 20)
                }
                Spacer()
                    .frame(height: 20)
                NavigationLink(destination: CreditsView()) {
                    Text("Game Credits")
                        .foregroundColor(.primary)
                        .font(.customHeadline)
                        .frame(height: 20)
                }
                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
