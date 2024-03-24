//
//  PhotoView.swift
//  PhotoAlbum
//
//  Created by Jacek Kosinski U on 23/03/2024.
//

import SwiftUI
import SwiftData

struct PhotoView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var formType: ModelFormType?

    let photo: PhotoModel
    var body: some View {
        VStack {
            Text(photo.name)
                .font(.largeTitle)
            ZoomableScrollView{
                Image(uiImage: photo.image == nil ? Constants.placeholder : photo.image!)
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
 
            }
            HStack{
                Button("Edit") {
                    formType = .update(photo)
                }
                .sheet(item: $formType) {$0}
                Button("Delete",role: .destructive) {
                    modelContext.delete(photo)
                    try? modelContext.save()
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity,alignment: .trailing)
            Spacer()
        }
        .padding()
        .navigationTitle("Photo View")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let container = PhotoModel.preview
    let fetchDescriptor = FetchDescriptor<PhotoModel>()
    let photo = try! container.mainContext.fetch(fetchDescriptor).first!
    return NavigationStack { PhotoView(photo:photo) }
}
