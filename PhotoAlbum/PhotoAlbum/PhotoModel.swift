//
//  PhotoModel.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 22/03/2024.
//

import UIKit
import SwiftData

@Model
class PhotoModel {
    var name: String
    @Attribute(.externalStorage)
    var data: Data?

    var image: UIImage? {
        if let data {
            return UIImage(data:data)
        } else {
            return nil
        }
    }
}

extension PhotoModel {
    @MainActor
    static var preview: ModelContainer
}
