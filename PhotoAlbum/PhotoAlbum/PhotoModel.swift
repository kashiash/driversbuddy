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

    init(name: String, data: Data? = nil) {
        self.name = name
        self.data = data
    }
}

extension PhotoModel {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for:  PhotoModel.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )

        var samples: [PhotoModel] {
            [
                .init(name: "Sample 1"), .init(name: "Sample 2"), .init(name: "Sample 3")
            ]
        }

        samples.forEach {
            container.mainContext.insert($0)
        }
        return container
    }
}
