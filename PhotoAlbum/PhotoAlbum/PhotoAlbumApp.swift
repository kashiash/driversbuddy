//
//  PhotoAlbumApp.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 22/03/2024.
//

import SwiftUI
import SwiftData

@main
struct PhotoAlbumApp: App {
    var body: some Scene {
        WindowGroup {
            PhotosListView()
        }
        .modelContainer(for: PhotoModel.self)
    }
}
