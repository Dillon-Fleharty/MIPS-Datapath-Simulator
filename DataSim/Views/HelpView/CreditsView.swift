//
//  CreditsView.swift
//  DataSim
//
//  Created by Carson Rau on 4/3/23.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        HStack(alignment: .top) {
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .animation(.default)
                Text("Carson Rau")
                    .font(.customBody)
                    .foregroundColor(.primary)
                Text("App Design and UX Development")
                    .multilineTextAlignment(.center)
                    .font(.customSubtitle)
                    .foregroundColor(.blue)
            }
            .animation(.default)
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .animation(.default)
                Text("Dillon Fleharty")
                    .font(.customBody)
                    .foregroundColor(.primary)
                Text("Image/Graphic Design and Processor Modelling")
                    .multilineTextAlignment(.center)
                    .font(.customSubtitle)
                    .foregroundColor(.blue)
            }
            .animation(.default)
            Spacer()
            VStack(alignment: .center) {
                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .animation(.default)
                Text("Rene Carbajal")
                    .font(.customBody)
                    .foregroundColor(.primary)
                Text("Instruction encoding and Processor Modelling")
                    .multilineTextAlignment(.center)
                    .font(.customSubtitle)
                    .foregroundColor(.blue)
            }
            .animation(.default)
            Spacer()
        }
    }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        CreditsView()
    }
}
