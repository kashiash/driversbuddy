//
//  SwiftMaterialExamples.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 25/03/2024.
//

import SwiftUI

struct SwiftMaterialExamples: View {
    var body: some View {
        VStack {
    
            Text("Ultra thin material")
                .font(.title)
                .padding()
                .background(.ultraThinMaterial)

            Text("Thin material")
                .font(.title)
                .padding()
                .background(.thinMaterial)

            Text("Regular material")
                .font(.title)
                .padding()
                .background(.regularMaterial)

            Text("Thick material")
                .font(.title)
                .padding()
                .background(.thickMaterial)

            Text("Ultra thick material")
                .font(.title)
                .padding()
                .background(.ultraThickMaterial)

            Text("Bar material")
                .font(.title)
                .padding()
                .background(.bar)
        }


        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.red)
    }
}

#Preview {
    SwiftMaterialExamples()
}
