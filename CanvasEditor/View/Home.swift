//
//  Home.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 22/12/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var canvasModel: CanvasViewModel = .init()
    
    var body: some View{
        ZStack{
            Color.black.ignoresSafeArea()
            //MARK: Canvas View
            Canvas()
                .environmentObject(canvasModel)
            
            //MARK: Canvas Actions
            HStack(spacing: 15){
                Button{
                    
                } label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                }
                Spacer()
                Button{
                    canvasModel.showImagePicer.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxHeight: .infinity,alignment: .top)
            
            //MARK: SAVE Button
            Button{
                canvasModel.saveCanvasImage(height: 250){
                    Canvas().environmentObject(canvasModel)
                }
            } label: {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .bottomTrailing)
        }
        .preferredColorScheme(.dark)
        .alert(canvasModel.errorMessage, isPresented: $canvasModel.showError){}
        .sheet(isPresented: $canvasModel.showImagePicer) {
            if let image = UIImage(data: canvasModel.imageData){
                canvasModel.addImageToStack(image: image)
            }
        } content: {
            ImagePicker(showPicker: $canvasModel.showImagePicer, imageData: $canvasModel.imageData)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
