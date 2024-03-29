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
    @Binding var canvasNewModel: CanvasObservableModel

    var body: some View {
        GeometryReader{ proxy in
          let  size = proxy.size

            ZStack{
                Color.white

                Image("car-cutout")
                    .resizable()
                    .gesture(        
                        SpatialTapGesture()
                        .onEnded { event in
                            print( "geture \(event.self) \(event.location) on size \(size)")
                            if let damage = canvasNewModel.selectedDamage {

                                canvasModel.addSymbolToStack(damage: damage,
                                                             location: event.location,canvasSize: size)
                            }
                        })

                    .scaledToFit()
                    .scaledToFill()

                    .frame(width: proxy.size.width,height:proxy.size.height)


                ForEach($canvasModel.stack) { $stackItem in


                    CanvasSubView(stackItem: $stackItem) {
                        stackItem.view
                    } moveFront: {
                        canvasModel.currentlyTappedItem = stackItem
                        moveViewToFront(stackItem: stackItem)
                    } onDelete: {
                        //MARK: Ask if user doesnt make mistake tapped
                        canvasModel.currentlyTappedItem = stackItem
                        canvasModel.showDeleteAlert.toggle()
                    } onInsert: {

                    }
                }
            }
            .frame(width: size.width, height: size.height)

        }
        //MARK:Your desired height
        .frame(maxHeight:.infinity)
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




    struct Canvas_Previews: PreviewProvider {
        static var previews: some View {
            Home()
        }
    }


    struct CanvasSubView <Content: View> : View {
        var content: Content
        @Binding var stackItem: StackItem
        @State var showEditAlert: Bool = false
        @State var showEditSheet: Bool = false

        var moveFront: () -> ()
        var onDelete: () -> ()
        var onInsert: () -> ()

        init(stackItem: Binding<StackItem>,@ViewBuilder content: @escaping ()-> Content,
             moveFront: @escaping ()->(),
             onDelete: @escaping () -> (),
             onInsert: @escaping () -> ()
        ){
            self.content = content()
            self._stackItem = stackItem
            self.moveFront = moveFront
            self.onDelete = onDelete
            self.onInsert = onInsert
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
                            print("DOUBLE TAP")
                            //onDelete()
                            showEditAlert.toggle()
                        })
                        .simultaneously(with:
                                            LongPressGesture(minimumDuration: 0.3)
                            .onEnded({_ in
                                print("LONG PRESS TAP")
                                UIImpactFeedbackGenerator(style: .medium)
                                    .impactOccurred()
                                withAnimation(.easeInOut) {
                                    hapticScale = 2.2
                                }
                                withAnimation(.easeInOut.delay(0.1)) {
                                    hapticScale = 1
                                }
                                moveFront()
                                showEditSheet.toggle()
                            })
                                       )
                )

                .onLongPressGesture(minimumDuration: 0.3) {
                    print("LONG PRESS TAP")
                    UIImpactFeedbackGenerator(style: .medium)
                        .impactOccurred()
                    withAnimation(.easeInOut) {
                        hapticScale = 2.2
                    }
                    withAnimation(.easeInOut.delay(0.1)) {
                        hapticScale = 1
                    }
                    moveFront()
                    showEditSheet.toggle()
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

                .alert("Add damage description?", isPresented: $showEditAlert) {

                    VStack {
                        TextField(stackItem.damage.rawValue,text: $stackItem.dscription, axis: .vertical)
                   

                        Button(role: .destructive) {
                            onDelete()
                        } label: {
                            Text("Delete")
                        }
                        Button {

                        } label: {
                            Text("Save")
                        }
                    }
                    .foregroundColor(.blue)
                }
                .sheet(isPresented: $showEditSheet) {

                } content: {
                    VStack {
                        TextField(stackItem.damage.rawValue,text: $stackItem.dscription, axis: .vertical)
                       // TextEditor(text: $stackItem.dscription)
                        Image("rysa1")
                            .resizable()
                            .scaledToFill()
                            .scaledToFit()
                            .font(.largeTitle)
                        HStack{
                            Spacer()
                            Button(role: .destructive) {
                                onDelete()
                            } label: {
                                Text("Delete")
                            }
                            Button {

                            } label: {
                                Text("Save")
                            }
                        }
                    }

                }
        }

    }
}
