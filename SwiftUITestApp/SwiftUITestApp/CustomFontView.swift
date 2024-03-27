//
//  SwiftUIView.swift
//  SwiftUITestApp
//
//  Created by Jacek Kosinski U on 26/03/2024.
//

import SwiftUI

struct CustomFontView: View {
    let title: String
    let description: String
    let font: Font

    var body: some View {

            NavigationLink(destination: {
                Form{
                    Section {
                        Text(title)
                            .font(font)
                            .background(.thinMaterial, in: .ellipse)

                        Text(description)
                            .font(.subheadline)
                    }
                    Section ("Default"){
                        Text(loremIpsum)
                            .font(font)
                            .fontWidth(.standard)
                    }
                    Section ("Compressed"){
                        Text(loremIpsum)
                            .font(font)
                            .fontWidth(.compressed)
                    }
                    Section ("Condensed"){
                        Text(loremIpsum)
                            .font(font)
                            .fontWidth(.condensed)
                    }
                            Section ("Expanded"){
                                Text(loremIpsum)
                                    .font(font)
                                    .fontWidth(.expanded)

                    }
                }
            }, label: {
                VStack{
                    Text(title)
                        .font(font)

                    Text(description)
                        .font(.subheadline)

                }
            })
    }


    let loremIpsum = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Tristique senectus et netus et malesuada fames ac. Mollis aliquam ut porttitor leo a. Consequat mauris nunc congue nisi vitae. Non consectetur a erat nam. Blandit libero volutpat sed cras ornare arcu. Aliquet lectus proin nibh nisl condimentum id. Vitae et leo duis ut diam quam nulla porttitor massa. Aenean et tortor at risus viverra. Consectetur purus ut faucibus pulvinar elementum. Tempus quam pellentesque nec nam aliquam sem et tortor. Enim ut sem viverra aliquet eget. Dignissim cras tincidunt lobortis feugiat vivamus at augue.
"""




}

#Preview {
    FontExamplesView()
}
