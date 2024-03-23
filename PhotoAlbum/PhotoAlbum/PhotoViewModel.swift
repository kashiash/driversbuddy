//
//  PhotoViewModel.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 23/03/2024.
//

import UIKit

@Observable
class PhotoViewModel {
    var name: String = ""
    var data: Data?

    var photo: PhotoModel?

    var image: UIImage {
        if let data, let uiImage = UIImage(data: data) {
            return uiImage
        } else {
            return Constants.placeholder
        }
    }

    init() {}

    init(photo: PhotoModel) {
        self.photo = photo
        self.name = photo.name
        self.data = photo.data
    }

    @MainActor
    func clearImage() {
        data = nil
    }

    var isUpdating: Bool { photo != nil }
    var isDisabled: Bool { name.isEmpty }

}
