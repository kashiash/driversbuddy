//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
//

import SwiftUI

struct FontWeightExamples: View {
    @State var color = Color.red

    var body: some View {
        ColorPicker("ColorPicker", selection: $color)
            .padding()
        List {

                
                CustomFontWeightView(title: "Black",
                                     description: "The boldest font weight.",
                                     font: .system(size: 24, weight: .black))

                CustomFontWeightView(title: "Bold",
                                     description: "A strong font weight.",
                                     font: .system(size: 24, weight: .bold))
                
                CustomFontWeightView(title: "Heavy",
                                     description: "A heavy font weight.",
                                     font: .system(size: 24, weight: .heavy))
                
                CustomFontWeightView(title: "Light",
                                     description: "A light font weight.",
                                     font: .system(size: 24, weight: .light))
                
                CustomFontWeightView(title: "Medium",
                                     description: "A medium font weight.",
                                     font: .system(size: 24, weight: .medium))
                
                CustomFontWeightView(title: "Regular",
                                     description: "The default font weight.",
                                     font: .system(size: 24, weight: .regular))
                
                CustomFontWeightView(title: "Semibold",
                                     description: "A semi-bold font weight.",
                                     font: .system(size: 24, weight: .semibold))
                
                CustomFontWeightView(title: "Thin",
                                     description: "A thin font weight.",
                                     font: .system(size: 24, weight: .thin))
                
                CustomFontWeightView(title: "Ultra Light",
                                     description: "The lightest font weight.",
                                     font: .system(size: 24, weight: .ultraLight))

        }
        .  foregroundColor(color)


    }
}

struct CustomFontWeightView: View {
    let title: String
    let description: String
    let font: Font

    var body: some View {

            Text(title)
                .font(font)


            Text(description)
                .font(.subheadline)

    }
}

#Preview {
    FontWeightExamples()
}

