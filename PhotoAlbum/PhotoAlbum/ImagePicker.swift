//
//  ImagePicker.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 24/03/2024.
//

import SwiftUI
import PhotosUI

class ImagePicker{

    var image:Image?
    var images: [Image] = []


    var vm: PhotoViewModel?

    func setup(_ vm: PhotoViewModel) {
        self.vm = vm
    }
    var imageSelection: PhotosPickerItem? {
        didSet {
            if let imageSelection {
                Task {
                    try await loadTransferable(from: imageSelection)
                }
            }
        }
    }

    @MainActor
    func loadTransferable(from imageSelection: PhotosPickerItem?) async throws {
        do {
            if let data = try await imageSelection?.loadTransferable(type: Data.self) {
                vm?.data = data
                if let uiImage = UIImage(data: data) {
                    self.image = Image(uiImage: uiImage)
                }
            }
        } catch {
            print(error.localizedDescription)
            image = nil
        }
    }


}

