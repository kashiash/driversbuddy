//
//  CanvasViewModel.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 22/12/2022.
//

import SwiftUI

class CanvasViewModel:NSObject, ObservableObject {
    //MARK: Canvas Stack
    @Published var stack: [StackItem] = []
    
    //MARK: Image picker Properties
    
    @Published var showImagePicer: Bool = false
    @Published  var imageData: Data = .init(count: 0)
    
    //MARK: Error properties
    @Published var showError: Bool = false
    @Published var errorMessage: String = ""
    
    
    //MARK: Delete Alert
    @Published var showDeleteAlert: Bool = false
    @Published var currentlyTappedItem: StackItem?
    
    //MARK: Adding Image to Stack
    func addImageToStack(image: UIImage){
        //MARK: creating SwiftUi Image View and append it to stack
        let imageView = Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
        
        stack.append(StackItem(view:AnyView(imageView)))
    }
    
    func saveCanvasImage<Content: View>(height:CGFloat, @ViewBuilder content: @escaping () -> Content){
        // removing safe area because it pushing view to bottom
        let uiView = UIHostingController(rootView: content().padding(.top,-safeArea().top))
        let frame = CGRect(origin: .zero, size:CGSize(width: UIScreen.main.bounds.width, height: height))
        uiView.view.frame = frame
        
        //MARK: Drawing Image
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0) // Change scale for better quality
        uiView.view.drawHierarchy(in: frame, afterScreenUpdates: true)
        //Retriewing current drawn image
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        //Closing context
        UIGraphicsEndImageContext()
        if let newImage = newImage {
            //print(newImage.pngData())
            writeToAlbum(image: newImage)
        }
        
    }
    
    //MARK: Writing To Album
    func writeToAlbum(image:UIImage){
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    @objc
    func saveCompletion(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
        if let error = error {
            self.errorMessage = error.localizedDescription
            self.showError.toggle()
        } else {
            self.errorMessage = "Saved Sucessfully"
            self.showError.toggle()
        }
    }
    
    func safeArea() -> UIEdgeInsets{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

