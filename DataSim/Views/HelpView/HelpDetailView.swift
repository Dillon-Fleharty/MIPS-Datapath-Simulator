//
//  HelpDetailView.swift
//  DataSim
//
//  Created by Carson Rau on 5/11/23.
//

import SwiftUI

struct HelpDetailView: View {
    private let data: HelpInfo
    private let kind: DatapathComponent
    init(_ kind: DatapathComponent) {
        self.kind = kind
        self.data = HelpData.getInfo(for: kind)
    }
    var body: some View {
        VStack {
            HStack {
                Text(kind.rawValue)
                    .font(.customLargeTitle)
                Spacer()
                DatapathElementPreviewView(kind)
                    .frame(width: 100, height: 100)
            }
            .padding([.leading, .trailing], 50)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Action:")
                        .font(.customHeadline)
                    Text(data.action)
                        .font(.customBody)
                        .padding(.horizontal)
                    Text("Inputs:")
                        .font(.customHeadline)
                    Text(data.inputs)
                        .padding(.horizontal)
                    Text("Outputs:")
                        .font(.customHeadline)
                    Text(data.outputs)
                        .padding(.horizontal)
                    Text("Uses:")
                        .font(.customHeadline)
                    ForEach(data.uses, id: \.self) { use in
                        Text(use)
                            .padding(.horizontal)
                    }
                }
                .font(.customBody)
                .padding()
            }
            .background(Color(.systemBackground))
        }
    }
}
