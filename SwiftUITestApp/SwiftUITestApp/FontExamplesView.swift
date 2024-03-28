//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
//

import SwiftUI

struct FontExamplesView: View {
    @State private var selectedWeight = Font.Weight.regular
    @State private var selectedWidth = Font.Width.standard
    @State private var selectedDesign = Font.Design.default

    @State private var color = Color.black
    @State private var bolded = false
    @State private var italic = false

    @State private var selectweight = false
    @State private var selectwidth = false
    @State private var selectdesign = false

    var body: some View {
        NavigationStack{
            VStack{

                VStack(alignment: .center) {
                    List{
                        CustomFontView(title: "Large Title",
                                       description: "The font style for large titles.",
                                       font: .largeTitle)
                        CustomFontView(title: "Title",
                                       description: "The font used for first level hierarchical headings.",
                                       font: .title)

                        CustomFontView(title: "Title 2",
                                       description: "The font used for second level hierarchical headings.",
                                       font: .title2)

                        CustomFontView(title: "Title 3",
                                       description: "The font used for third level hierarchical headings.",
                                       font: .title3)

                        CustomFontView(title: "Headline",
                                       description: "The font used for headings.",
                                       font: .headline)

                        CustomFontView(title: "Subheadline",
                                       description: "The font used for subheadings.",
                                       font: .subheadline)

                        CustomFontView(title: "Body",
                                       description: "The font used for body text.",
                                       font: .body)

                        CustomFontView(title: "Callout",
                                       description: "The font used for callouts.",
                                       font: .callout)

                        CustomFontView(title: "Caption",
                                       description: "The font used for standard captions.",
                                       font: .caption)

                        CustomFontView(title: "Caption 2",
                                       description: "The font used for alternate captions.",
                                       font: .caption2)

                        CustomFontView(title: "Footnote",
                                       description: "The font used in footnotes.",
                                       font: .footnote)
                    }
                    .bold(bolded)
                    .italic(italic)
                    .fontDesign(selectedDesign)
                    .fontWeight(selectedWeight)
                    .fontWidth(selectedWidth)
                    .foregroundColor(color)
                    .toolbar{
                        ToolbarItem(placement: .bottomBar) {
                            Toggle("b", isOn: $bolded)
                                .bold()
                        }

                        ToolbarItem(placement: .bottomBar) {
                            Toggle("i", isOn: $italic)
                                .italic()
                        }

                        ToolbarItem(placement: .bottomBar) {
                            ColorPicker("",selection: $color)
                                .pickerStyle(.palette)
                        }

                        ToolbarItem(placement: .automatic) {
                            Button("Weight"){
                                selectweight.toggle()
                            }
                        }
                        ToolbarItem(placement: .automatic) {
                            Button("Width"){
                                selectwidth.toggle()
                            }
                        }
                        ToolbarItem(placement: .automatic) {
                            Button("Design"){
                                selectdesign.toggle()
                            }
                        }
                    }

                    .sheet(isPresented: $selectdesign)
                    {
                        Picker("Font Design", selection: $selectedDesign) {
                            Text("Default").tag(Font.Design.default)
                                .font( .system(size: 24, design: .default))
                            Text("Serif").tag(Font.Design.serif)
                                .font( .system(size: 24, design: .serif))
                            Text("Monospaced").tag(Font.Design.monospaced)
                                .font( .system(size: 24, design: .monospaced))
                            Text("Rounded").tag(Font.Design.rounded)
                                .font( .system(size: 24, design: .rounded))
                        }
                        .pickerStyle(.wheel)
                        .presentationDetents([.medium, .large])


                    }

                    .sheet(isPresented: $selectwidth)
                    {
                        Picker("Font Width", selection: $selectedWidth) {

                            Text("Compressed").tag(Font.Width.compressed).fontWidth(.compressed)
                            Text("Condensed").tag(Font.Width.condensed).fontWidth(.condensed)
                            Text("Standard").tag(Font.Width.standard).fontWidth(.standard)
                            Text("Expanded").tag(Font.Width.expanded).fontWidth(.expanded)

                        } 
                        .pickerStyle(.inline)
                        .presentationDetents([.medium, .large])
                    }

                    .sheet(isPresented: $selectweight)
                    {
                        Picker("Font Weight", selection: $selectedWeight) {
                            Text("Black").tag(Font.Weight.black).fontWeight(.black)
                            Text("Heavy").tag(Font.Weight.heavy).fontWeight(.heavy)
                            Text("Bold").tag(Font.Weight.bold).fontWeight(.bold)
                            Text("Semibold").tag(Font.Weight.semibold).fontWeight(.semibold)
                            Text("Medium").tag(Font.Weight.medium).fontWeight(.medium)
                            Text("Regular").tag(Font.Weight.regular).fontWeight(.regular)
                            Text("Light").tag(Font.Weight.light).fontWeight(.light)
                            Text("Thin").tag(Font.Weight.thin).fontWeight(.thin)
                            Text("Ultra Light").tag(Font.Weight.ultraLight).fontWeight(.ultraLight)
                        }
                        .pickerStyle(.inline)
                        .presentationDetents([.medium, .large])
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
#Preview {
    FontExamplesView()
}
