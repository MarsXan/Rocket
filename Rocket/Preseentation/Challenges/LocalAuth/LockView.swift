//
//  LockView.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/6/23.
//

import SwiftUI
import LocalAuthentication
// Custom View
struct LockView<Content: View>: View {
    // Lock Properties
    var lockType: LockType
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesBackground: Bool = true
    var forgotPin: () -> () = { }
    @ViewBuilder var content: Content

    @State private var pin: String = ""
    @State private var isUnlocked: Bool = false
    @State private var animateField: Bool = false
    @State private var noBiometricAccess: Bool = false
    @Environment(\.scenePhase) private var phase
    let context = LAContext()
    var body: some View {
        GeometryReader {
            let size = $0.size

            content
                .frame(width: size.width, height: size.height)

            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text ("Enable biometric authentication in Settings tounlock the view.")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                            } else {
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "lock")
                                            .font(.largeTitle)
                                        Text("Tap to Unlock")
                                            .font(.caption2)
                                            .foregroundStyle(.gray)
                                    }
                                        .frame(width: 100, height: 100)
                                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                        .contentShape(.rect)
                                        .onTapGesture {
                                            unlockView()
                                    }

                                    if lockType == .both {
                                        Text("Enter Pin")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        NumberPadPinView()
                    }
                }
                    .environment(\.colorScheme, .dark)
                    .transition(.offset(y: size.height + 100))
            }
        }.onChange(of: isEnabled, initial: true){oldValue,newValue in
            if newValue{
                unlockView()
            }
        }
        .onChange(of: phase){oldValue,newValue in
            if newValue != .active && lockWhenAppGoesBackground{
                isUnlocked = false
                pin = ""
            }
        }
    }

    private func unlockView() {
        Task{
            if isBiometricAvailable() && lockType != .number {
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock the View"),result{
                    withAnimation(.snappy,completionCriteria:.logicallyComplete){
                        isUnlocked = true
                    }completion: {
                        pin = ""
                    }
                }
            }
            
            // no bio metric Permission || Lock Type Must be as keypad
            noBiometricAccess = !isBiometricAvailable()
        }
    }
    
    private func isBiometricAvailable() -> Bool{
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
    @ViewBuilder
    private func NumberPadPinView() -> some View {
        VStack(spacing: 15) {
            Text("Enter Pin")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment:.leading){
                    if lockType == .both && isBiometricAvailable(){
                        Button{
                            pin = ""
                            noBiometricAccess = false
                        }label: {
                            Image(systemName: "arrow.left")
                                .font(.title3)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                        .padding(.leading)
                    }
                }

            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle (cornerRadius: 10)
                        .fill(Color.white)
                        .frame (width: 50, height: 55)
                        .overlay {
                        if pin.count > index {
                            let i = pin.index(pin.startIndex, offsetBy: index)
                            let text = String(pin[i])
//
                            Text(text)
                                .font(.title.bold())
                                .foregroundStyle(.black)
                        }
                    }
                }
            }
                .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                content.offset(x: value)
            }, keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)
                }
            })
                .overlay(alignment: .bottomTrailing) {
                Button("Forget Pin?", action: forgotPin)
                    .font(.caption)
                    .foregroundStyle(.white)
                    .offset(y: 40)
            }
                .frame (maxHeight: .infinity)

            GeometryReader { _ in
                LazyVGrid(columns: Array (repeating: GridItem(), count: 3), content: {
                    ForEach(1...9, id: \.self) { number in
                        Button(action: {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        }, label: {
                            Text ("\(number)")
                                .font (.title)
                                .frame(maxWidth: .infinity)
                                .padding (. vertical, 20)
                                .contentShape (.rect)
                        })
                            .tint (.white)
                    }
                    Button(action: {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    }, label: {
                        Image(systemName: "delete.backward")
                            .font (.title)
                            .frame(maxWidth: .infinity)
                            .padding (. vertical, 20)
                            .contentShape (.rect)
                    })
                        .tint (.white)

                    Button(action: {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    }, label: {
                        Text ("0")
                            .font (.title)
                            .frame(maxWidth: .infinity)
                            .padding (. vertical, 20)
                            .contentShape (.rect)
                    })
                        .tint (.white)

                })
                    .frame (maxHeight: .infinity, alignment: .bottom)
            }
                .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        withAnimation(.snappy,completionCriteria:.logicallyComplete){
                            isUnlocked = true
                        }completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable()
                        }
                    } else {
                        pin = ""
                        animateField.toggle()
                    }
                }

            }


                .padding()
                .environment (\.colorScheme, .dark)
        }
    }


}//

#Preview {
    LockMainView()
}
