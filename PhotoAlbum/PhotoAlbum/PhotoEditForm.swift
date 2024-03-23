//
//  PhotoEditForm.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 24/03/2024.
//

import SwiftUI
import SwiftData
import PhotosUI

struct PhotoEditForm: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State var vm: PhotoViewModel
    var body: some View {
        NavigationStack{
            Form{
                TextField("Name", text: $vm.name)
                VStack {
                    if vm.data != nil {
                        Button("Clear Image")  {
                            vm.clearImage()
                        }
                        .buttonStyle(.bordered)
                    }
                    HStack{
                        Button("Camera", systemImage: "camera") {

                        }
                        Spacer()
                        Button("Album", systemImage: "photo") {

                        }
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)

                }
            }
        }
    }
}

#Preview {
    PhotoEditForm(vm: PhotoViewModel())
}
