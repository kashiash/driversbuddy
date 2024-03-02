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

    func makeUIView(context: Context) -> UIView {
        return UIView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard !context.coordinator.isMasked else { return }

            if let rootView = uiView.viewBeforeWindow {
                let safeArea = rootView.safeAreaInsets
                rootView.frame = CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: rootView.frame.width,
                        height: rootView.frame.height - (self.height + safeArea.bottom)
                    )
                )

                rootView.clipsToBounds = true
                for  view in rootView.subviews {
                    //removing shadows
                    view.layer.shadowColor = UIColor.clear.cgColor

                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubViews.first(where: {$0.layer.animationKeys()?.contains("cornerRadius") ?? false}) {
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
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

    // Retriving subvies from UIView
    var allSubViews: [UIView] {
        return subviews.flatMap {
            [$0] + $0.subviews
        }
    }
}

#Preview {
    ContentView()
}
