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
    @State private var imagePicker = ImagePicker()
    @State private var showCamera = false
    @State private var cameraError: CameraPermission.CameraError?

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
                            if let error = CameraPermission.checkPermissions() {
                                cameraError = error
                            } else {
                                showCamera.toggle()
                            }

                        }
                        .alert(isPresented: .constant(cameraError != nil), error: cameraError) {_ in
                            Button("OK") {
                                cameraError = nil
                            }
                        } message: { error in
                            Text(error.recoverySuggestion ?? "try again later")
                        }
                        .sheet(isPresented: $showCamera) {
                            UIKitCamera(selectedImage: $vm.cameraImage)
                                .ignoresSafeArea()
                        }

                        Spacer()
                        PhotosPicker(selection: $imagePicker.imageSelection , label: {
                            Label("Photos",systemImage: "photo")
                        })
                    }
                    .foregroundStyle(.white)
                    .buttonStyle(.borderedProminent)
                    Image(uiImage: vm.image)
                        .resizable()
                        .scaledToFill()

                }
            }
            .onAppear {
                imagePicker.setup(vm)
            }
            .onChange(of: vm.cameraImage) {
                if let image = vm.cameraImage {
                    vm.data = image.jpegData(compressionQuality: 0.8)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel"){
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button{
                        if vm.isUpdating {
                            if let photo = vm.photo {
                                if vm.image != Constants.placeholder {
                                    photo.data = vm.image.jpegData(compressionQuality: 0.8)
                                } else  {
                                    photo.data = nil
                                }
                                photo.name = vm.name
                                dismiss()
                            }
                        } else {
                            let newPhoto = PhotoModel(name: vm.name)
                            if vm.image != Constants.placeholder {
                                newPhoto.data = vm.image.jpegData(compressionQuality: 0.8)
                            } else {
                                newPhoto.data = nil
                            }
                            modelContext.insert(newPhoto)
                            dismiss()
                        }
                    } label: {
                        Text(vm.isUpdating ? "Update" : "Add")
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoEditForm(vm: PhotoViewModel())
}
