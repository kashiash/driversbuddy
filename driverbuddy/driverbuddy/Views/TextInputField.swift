//
//  TextInputField.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 05/03/2024.
//

import SwiftUI

struct TextInputField: View {
    var title: String
    @Binding var text: String

    init(_ title:String ,text:Binding<String>) {
        self.title = title
        self._text = text
    }
    var body: some View {

            ZStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(text.isEmpty ?  Color(.placeholderText) : .accentColor)
                    .offset(y: text.isEmpty ? 0: -25)
                    .scaleEffect(text.isEmpty ? 1: 0.8,anchor: .leading)

                TextField("", text: $text)
                    .padding(.trailing,12)
                    .overlay(
                        HStack {
                            Spacer()
                            Button(action: {
                                text = ""
                            }, label: {
                                Image(systemName:"multiply.circle.fill")
                                    .foregroundColor(Color(.systemGray))
                        })
                        }
                    )
            }
            .padding(.top,15)
            .animation(
                .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                value: 1.5
            )

    }
}

#Preview {


    TextInputField("First Name", text: .constant("Some value"))

}

#Preview {
    TextInputField("First Name", text: .constant("Some value terefere dlugi napis. poszly konie po betonie"))
        .preferredColorScheme(.dark)
}
