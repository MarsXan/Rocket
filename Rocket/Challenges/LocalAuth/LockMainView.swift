//
//  LockMainView.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/6/23.
//

import SwiftUI

struct LockMainView: View {
    var body: some View {
        LockView(lockType: .both, lockPin: "1234", isEnabled: true, lockWhenAppGoesBackground: true){
            VStack(spacing:16){
                Image(systemName: "globe")
                    .imageScale(.large)
                
                Text("Hello World")
            }
        }
    }
}

#Preview {
    LockMainView()
}
