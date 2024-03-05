//
//  SwiftUIView.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 05/03/2024.
//

import SwiftUI

struct TextIconField: View {
    var title: String
    @Binding var text: String
    var systemName: String

    init(_ title:String ,text:Binding<String>, systemName: String) {
        self.title = title
        self._text = text
        self.systemName = systemName
    }

    var body: some View {
        HStack{
            Image(systemName:systemName).frame(width:25)
            TextField(title, text: $text)
        }
    }
}

#Preview {
    TextIconField("First Name", text: .constant("Some value"),systemName: "square.and.arrow.up.trianglebadge.exclamationmark")
}
