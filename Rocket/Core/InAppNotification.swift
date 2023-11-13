//
//  InAppNotification.swift
//  Rocket
//
//  Created by mohsen mokhtari on 11/12/23.
//

import SwiftUI

extension UIApplication {
    func inAppNotification<Content: View> (adaptForDynamicIsland: Bool = true, timeout: CGFloat = 5, swipeToClose: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        /// Fetching Active Window VIA WindowScene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first (where: { $0.isKeyWindow }) {
            //I Frame and SafeArea Values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets
            let checkForDynamicIsland = adaptForDynamicIsland && safeArea.top >= 51
            // Creating UIView from SwiftUIView using UIHosting Configuration
            let config = UIHostingConfiguration {
                AnimatedNotificationView (content: content(), safeArea: safeArea, adaptForDynamicIsland: checkForDynamicIsland, timeout: timeout, swipeToClose: swipeToClose)
                    .frame(width: frame.width - (checkForDynamicIsland ? 20 : 30 ), height: 120, alignment: .top)
                    .contentShape(.rect)
            }
            
            // Creating UIView
            let view = config.makeContentView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = .clear
            activeWindow.addSubview(view)
            
            view.centerXAnchor.constraint(equalTo: activeWindow.centerXAnchor).isActive = true
            view.centerYAnchor.constraint(equalTo: activeWindow.centerYAnchor,constant: (-(frame.height - safeArea.top)/2) + (checkForDynamicIsland ? 11 : safeArea.top)).isActive = true
            
        }

    }
}

fileprivate struct AnimatedNotificationView<Content: View>: View {
    
    var content: Content
    var safeArea: UIEdgeInsets
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool
    @State private var animateNotification:Bool = true
    var body: some View {
        content
            .mask {
                if adaptForDynamicIsland {
                    RoundedRectangle (cornerRadius: 50, style: .continuous)
                } else {
                    Rectangle ()
                }
            }
            .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1 , anchor: .init(x: 0.5, y: 0.01))
            .onAppear (perform: {
                Task {
                    guard !animateNotification else { return }
                    withAnimation(.smooth) {
                        animateNotification = true
                    }
                    // Timeout For Notification
                    try await Task.sleep(for: .seconds(timeout < 1 ? 1: timeout))
                    guard animateNotification else { return }
                    withAnimation(.smooth, completionCriteria: .logicallyComplete) {
                        animateNotification = false
                    } completion:{
                    }
                }
            })
                
    }
    
}

#Preview {
   ContentView()
}
