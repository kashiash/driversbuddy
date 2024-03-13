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
        ZStack(alignment: .topTrailing){
            //MARK: Canvas View
            Canvas()
                .environmentObject(canvasModel)
           // Color.black.ignoresSafeArea()
            //MARK: Canvas Actions
            HStack(spacing: 15){
                Button{

                } label: {
                    Image(systemName: "xmark")

                }
                Spacer()
                Button{
                    canvasModel.showImagePicer.toggle()
                } label: {
                    Image(systemName: "car")

                }
                .padding()

                Button{
                    canvasModel.showImagePicer.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")

                }
                .padding()

                Button{
                    canvasModel.showImagePicer.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")

                }
                .padding()
                Spacer()
                Button{
                    canvasModel.saveCanvasImage(height: 250){
                        Canvas().environmentObject(canvasModel)
                    }
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
                .padding()
            }
          //  .foregroundColor(.white)
            .padding()
            .frame(maxHeight:.infinity,alignment: .top)

            VStack(spacing: 10) {
                Button("😱"){

                }.padding(.vertical)
                Button("☠️"){

                }.padding(.vertical)
                Button("👹"){

                }.padding(.vertical)
                Button("💩"){

                }
                .padding(.vertical)
            }

            .font(.title)
            .foregroundColor(.red)
            .offset(x: -10, y: 100)

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
