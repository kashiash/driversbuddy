//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
//

import SwiftUI

struct FontSimpleExamplesView: View {
    var body: some View {
        NavigationStack{
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
        }

    }
}

#Preview {
    FontSimpleExamplesView()
}
