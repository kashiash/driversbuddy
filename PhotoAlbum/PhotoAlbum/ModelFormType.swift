//
//  ModelFormType.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 24/03/2024.
//

import SwiftUI

enum ModelFormType:Identifiable, View {
    case new
    case update(PhotoModel)

    var id: String {
        String(describing: self)
    }

    var body: some View {
        switch self {

        case .new:
            PhotoEditForm(vm: PhotoViewModel())
        case .update(let photo):
            PhotoEditForm(vm: PhotoViewModel(photo: photo))
        }
    }
}
