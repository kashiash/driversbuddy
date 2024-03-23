//
//  ContentView.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 22/03/2024.
//

import SwiftUI
import SwiftData

struct PhotosListView: View {

    @Query(sort: \PhotoModel.name) var samples : [PhotoModel]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack{
            Group{
                if samples.isEmpty {
                    ContentUnavailableView("Add photo", systemImage: "photo")
                } else {
                    List(samples) { photo in
                        NavigationLink(value: photo) {
                            HStack{
                                Image(uiImage: photo.image == nil ? Constants.placeholder : photo.image!)
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: 50, height: 50)
                                 //  .cornerRadius(12)
                                   .clipShape(RoundedRectangle(cornerRadius: 12))
                                   .clipped()
                                   .padding(.trailing)
                                Text(photo.name)
                                    .font(.title)
                            }
                        }
                        .swipeActions{
                            Button(role: .destructive) {
                                modelContext.delete(photo)
                                try? modelContext.save()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(for: PhotoModel.self) { photo in
                PhotoView(photo: photo)
            }
            .navigationTitle("Picker or camera")
            .toolbar {
                Button {

                } label: {
Image(systemName: "plus.circle.fill")
                }
            }
        }
    }
}

#Preview {
    PhotosListView()
        .modelContainer(PhotoModel.preview)
}
