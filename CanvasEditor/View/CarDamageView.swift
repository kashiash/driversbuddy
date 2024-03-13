//
//  CarDamageView.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 12/03/2024.
//

import SwiftUI

import SwiftUI



struct CarDamageView: View {
    @State private var selectedDamage: CarDamage?

    var body: some View {
        VStack {
            Text("Select damage type:")
                .font(.headline)
            ForEach(CarDamage.allCases, id: \.self) { damage in
                Button(action: {
                    selectedDamage = damage
                }) {
                    HStack {
                        Image(systemName: selectedDamage == damage ? damage.symbol : damage.symbolSelected) // Display the emoji icon
                            .font(.title)
                            .foregroundColor(selectedDamage == damage ? .blue : .red)

                    }

                }
                .padding()
              //  .tooltip(damage.tooltip)
            }

        }
    }
}




#Preview {
    CarDamageView()
}
