//
//  BottomHelper.swift
//  driverbuddy
//
//  Created by Jacek Kosinski U on 02/03/2024.
//

import SwiftUI

extension  View {
    @ViewBuilder
    func bottomMaskForSheet(_ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(height: height))
    }
}

fileprivate struct SheetRootViewFinder: UIViewRepresentable {

    var height: CGFloat
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }


    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let rootView = uiView.viewBeforeWindow {
                let safeArea = rootView.safeAreaInsets
                // Updating height to add extra space in the bottom
                rootView.frame = .init(
                    origin: .zero,
                    size: .init(
                        width:rootView.frame.width,
                        height: rootView.frame.height - (height + safeArea.bottom)
                    )
                )

//                rootView.clipsToBounds = true
//                for  view rootView.subviews {
//                    //removing shadows
//                    view.layer.shadowColor = UIColor.clear.cgColor
//                }
            }
        }
    }

    class Coordinator: NSObject {
        var isMasked: Bool = false
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow { 
            return self
        }
        return superview?.viewBeforeWindow
    }
}

#Preview {
    ContentView()
}
