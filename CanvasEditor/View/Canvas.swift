//
//  Canvas.swift
//  CanvasEditor
//
//  Created by Jacek Kosinski U on 22/12/2022.
//

import SwiftUI

struct Canvas: View {
    var height: CGFloat = 460
    @EnvironmentObject var canvasModel: CanvasViewModel
    var body: some View {
        GeometryReader{ proxy in
            let size = proxy.size
            ZStack{
                Color.white
                
                ForEach($canvasModel.stack) { $stackItem in
                    
                    
                    CanvasSubView(stackItem: $stackItem) {
                        stackItem.view
                    } moveFront: {
                        moveViewToFront(stackItem: stackItem)
                    } onDelete: {
                        //MARK: Ask if user doesnt make mistake tapped
                        canvasModel.currentlyTappedItem = stackItem
                        canvasModel.showDeleteAlert.toggle()
                    }
                }
            }
            .frame(width: size.width, height: size.height)
        }
        //MARK:Your desired height
        .frame(height: height)
        .clipped()
        .alert("Are you sure to delete image?", isPresented: $canvasModel.showDeleteAlert) {
            Button(role: .destructive) {
                if let item = canvasModel.currentlyTappedItem{
                    let index = getIndex(stackItem: item)
                    canvasModel.stack.remove(at: index)
                }
            } label: {
                Text("Yes")
            }
        }
    }
    
    func moveViewToFront(stackItem: StackItem){
        //Find index and moving to last
        // Since in ZStack last item will show on first
        let curentIndex = getIndex(stackItem: stackItem)
        let lastIndex = canvasModel.stack.count - 1
        
        //Simplae swapping
        canvasModel.stack.insert(canvasModel.stack.remove(at: curentIndex), at:lastIndex)
    }
    
    func getIndex(stackItem: StackItem)-> Int{
        return canvasModel.stack.firstIndex { item in
            return item.id == stackItem.id
        } ?? 0
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}


struct CanvasSubView <Content: View> : View {
    var content: Content
    @Binding var stackItem: StackItem
    var moveFront: () -> ()
    var onDelete: () -> ()
    
    init(stackItem: Binding<StackItem>,@ViewBuilder content: @escaping ()-> Content, moveFront: @escaping ()->(), onDelete: @escaping () -> ()){
        self.content = content()
        self._stackItem = stackItem
        self.moveFront = moveFront
        self.onDelete = onDelete
    }
    
    @State var hapticScale: CGFloat = 1
    var body: some View {
        content
            .rotationEffect(stackItem.rotation)
        //safe scaling
            .scaleEffect(stackItem.scale < 0.4 ? 0.4 : stackItem.scale)
            .scaleEffect(hapticScale)
            .offset(stackItem.offset)
            .gesture(
                TapGesture(count: 2)
                    .onEnded({ _ in
                        onDelete()
                    })
                    .simultaneously(with:
                                        LongPressGesture(minimumDuration: 0.3)
                        .onEnded({_ in
                            UIImpactFeedbackGenerator(style: .medium)
                                .impactOccurred()
                            withAnimation(.easeInOut) {
                                hapticScale = 1.2
                            }
                            withAnimation(.easeInOut.delay(0.1)) {
                                hapticScale = 1
                            }
                            moveFront()
                            
                        })
                                   )
            )
            .onLongPressGesture(minimumDuration: 0.3) {
                UIImpactFeedbackGenerator(style: .medium)
                    .impactOccurred()
                withAnimation(.easeInOut) {
                    hapticScale = 1.2
                }
                withAnimation(.easeInOut.delay(0.1)) {
                    hapticScale = 1
                }
                moveFront()
            }
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        stackItem.offset = CGSize(width: stackItem.lastOffset.width +
                                                  value.translation.width, height: stackItem.lastOffset.height +
                                                  value.translation.height)
                    }).onEnded({value in
                        stackItem.lastOffset = stackItem.offset
                        
                    })
            )
            .gesture(
                MagnificationGesture()
                    .onChanged({value in
                        
                        //MARK: It start with Existing scaling = 1
                        stackItem.scale = stackItem.lastScale + (value - 1)
                    }).onEnded({ value in
                        stackItem.lastScale = stackItem.scale
                    })
                //MARK: Simultanously
                    .simultaneously(with:
                                        RotationGesture()
                        .onChanged({ value in
                            stackItem.rotation = stackItem.lastRotation + value
                        }).onEnded({ value in
                            stackItem.lastRotation = stackItem.rotation
                            
                        })
                                   )
            )
    }
}
