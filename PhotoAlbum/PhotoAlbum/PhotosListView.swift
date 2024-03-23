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
                    List(samples) { sample in
                        NavigationLink(value: sample) {
                            HStack{
                                Image(uiImage: sample.image == nil ? Constants.placeholder : sample.image!)
                                   .resizable()
                                   .scaledToFill()
                                   .frame(width: 50, height: 50)
                                   .cornerRadius(12)
                                   .clipped()
                                   .padding(.trailing)
                                Text(sample.name)
                                    .font(.title)
                            }
                        }
                        .swipeActions{
                            Button(role: .destructive) {
                                modelContext.delete(sample)
                                try? modelContext.save()
                            } label: {
                                Image(systemName: "trash")
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationDestination(for: PhotoModel.self) { sample in
                Text(sample.name)
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
