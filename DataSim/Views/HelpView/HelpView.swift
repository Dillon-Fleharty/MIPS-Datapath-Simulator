//
//  HelpView.swift
//  DataSim
//
//  Created by Carson Rau on 4/3/23.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationStack {
            VStack(alignment: .center) {
                Text("Gameplay and Datapath Help")
                .font(.customLargeTitle)
                .padding()
                .animation(.default)
                Spacer()
                ForEach(DatapathComponent.allCases, id: \.self) { comp in
                    NavigationLink {
                        HelpDetailView(comp)
                    } label: {
                        HStack(alignment: .center) {
                            Text(comp.rawValue)
                                .font(.customLargeTitle)
                                .foregroundColor(.primary)
                            Spacer()
                            DatapathElementPreviewView(comp)
                                .aspectRatio(contentMode: .fit)
                        }
                        .padding([.leading, .trailing], 50)
                    }
                }
                .animation(.default)
                Spacer()
                
            }
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
