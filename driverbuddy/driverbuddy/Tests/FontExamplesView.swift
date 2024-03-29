//
//  FontExamplesView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 25/03/2024.
//

import SwiftUI

struct FontExamplesView: View {
    @State private var selectedWeight = Font.Weight.regular
    @State private var selectedWidth = Font.Width.standard
    @State private var selectedDesign = Font.Design.default
    var body: some View {
        NavigationStack{
        VStack{
            HStack{

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

                Picker("Font Width", selection: $selectedWidth) {

                    Text("Compressed").tag(Font.Width.compressed).fontWidth(.compressed)
                    Text("Condensed").tag(Font.Width.condensed).fontWidth(.condensed)
                    Text("Standard").tag(Font.Width.standard).fontWidth(.standard)
                    Text("Expanded").tag(Font.Width.expanded).fontWidth(.expanded)

                } .pickerStyle(.inline)
                Picker("Font Design", selection: $selectedDesign) {
                    Text("Default").tag(Font.Design.default)
                    Text("Serif").tag(Font.Design.serif)
                    Text("Monospaced").tag(Font.Design.monospaced)
                    Text("Rounded").tag(Font.Design.rounded)
                }
                .pickerStyle(.inline)
            }
            VStack(alignment: .center) {


                    List{

                        CustomFontView(title: "Large Title",
                                       description: "The font style for large titles.",
                                       font: .largeTitle

                        )

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
                    .fontDesign(selectedDesign)
                    .fontWeight(selectedWeight)
                    .fontWidth(selectedWidth)

                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)


        }

    }

}



#Preview {
    FontExamplesView()
}
