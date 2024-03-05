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
    @Environment(\.clearButtonHidden) var clearButtonHidden
    @Environment(\.mykeyboardType) var mykeyboardType: UIKeyboardType

    init(_ title:String ,text:Binding<String>) {
        self.title = title
        self._text = text
    }


    var clearButton: some View {
        HStack {
            if !clearButtonHidden {
                Spacer()
                Button(action: {
                    text = ""
                }) {
                    Image(systemName:"multiply.circle.fill")
                        .foregroundColor(Color(.systemGray))
                }
            } else {
                EmptyView()
            }
        }
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
                        clearButton
                    )
                    .keyboardType(mykeyboardType)
            }
            .padding(.top,15)
            .animation(
                .easeInOut(duration: 1)
                    .repeatForever(autoreverses: false),
                value: 1.5
            )

    }
}

extension View {
  func clearButtonHidden(_ hidesClearButton: Bool = true) -> some View {
    environment(\.clearButtonHidden, hidesClearButton)
  }

    func mykeyboardType(_ mykeyboardType: UIKeyboardType = .default) -> some View {
      environment(\.mykeyboardType, mykeyboardType)
    }
}

private struct TextInputFieldClearButtonHidden: EnvironmentKey {
  static var defaultValue: Bool = false
}
private struct TextInputFieldKeyboardType: EnvironmentKey {
    static var defaultValue: UIKeyboardType = .default
}

extension EnvironmentValues {
  var clearButtonHidden: Bool {
    get { self[TextInputFieldClearButtonHidden.self] }
    set { self[TextInputFieldClearButtonHidden.self] = newValue }
  }

    var mykeyboardType: UIKeyboardType {
      get { self[TextInputFieldKeyboardType.self] }
      set { self[TextInputFieldKeyboardType.self] = newValue }
    }
}

#Preview {


    TextInputField("First Name", text: .constant("Some value"))
        .previewLayout(.sizeThatFits)
        .clearButtonHidden()

}

#Preview {
    TextInputField("First Name", text: .constant("Some value terefere dlugi napis. poszly konie po betonie"))
        .preferredColorScheme(.dark)
        .mykeyboardType(.decimalPad)
}
