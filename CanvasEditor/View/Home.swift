//
//  Home.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 22/12/2022.
//

import SwiftUI

struct Home: View {
    @StateObject var canvasModel: CanvasViewModel = .init()
    @State var canvasNewModel: CanvasObservableModel  = .init()

    var body: some View{
        ZStack(alignment: .topTrailing){
            //MARK: Canvas View
            Canvas( canvasNewModel: $canvasNewModel)
                .environmentObject(canvasModel)
             //   .environment(canvasNewModel)

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
                    if let damage = canvasNewModel.selectedDamage{
                        canvasModel.addSymbolToStack(systemName: damage.symbol)
                    }
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

            }
          //  .foregroundColor(.white)
            .padding()
            .frame(maxHeight:.infinity,alignment: .top)


            VStack(spacing: 10) {

                ForEach(CarDamage.allCases, id: \.self) { damage in
                    Button(action: {
                        canvasNewModel.selectedDamage = damage

                    }) {
                        HStack {
                            Image(systemName: canvasNewModel.selectedDamage == damage ? damage.symbol : damage.symbolSelected) // Display the emoji icon

                                .foregroundColor(canvasNewModel.selectedDamage == damage ? .blue : .red)
                        }
                    }
                    .font(.title)
                    .padding()
                    //  .tooltip(damage.tooltip)
                }
            }
            
            .offset(x: 0, y: 100)

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
