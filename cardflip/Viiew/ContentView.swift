
//
//  ContentView.swift
//  CardFlip
//
//  Created by Philippe MICHEL on 20/04/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var  image:Image?
    @State private var inputImage:UIImage?
    @State private var showView:Bool = false
    @State private var showLibrary:Bool = false
    @State private var speedDuration:Double = 2.0
    @State private var directRotation:Bool = true
    
    
    var body: some View {
        VStack {
            Text(LocalizedStringKey(stringLiteral: "titleDescription"))
                .font(.largeTitle)
                .padding()
            Text((image == nil) ? LocalizedStringKey(stringLiteral: "ruleOne") : LocalizedStringKey(stringLiteral: "ruleTwo"))
                .font(.subheadline)
            
            ZStack {
                if showView {
                    image?
                        .resizable()
                        .cornerRadius(10)
                        .transition(directRotation ?.reveseflip: .flip)
                        .onTapGesture {
                            guard !(image == nil) else {return}
                            withAnimation(.bouncy(duration: speedDuration)) {
                                self.showView.toggle()
                            }
                        }
                } else {
                    Image("dos")
                        .resizable()
                        .transition(directRotation ?.flip :.reveseflip)
                        .opacity(!(image == nil) ? 1 : 0.1)
                        .onTapGesture {
                            //pour faire rotation il faut avoir choisit une image
                            guard !(image == nil) else {return}
                            withAnimation(.bouncy(duration: speedDuration)) {
                                self.showView.toggle()
                            }
                        }
                }
            }
            .frame(width:200, height: 300)
            
            // ouvrir la lib de photo
            Button(LocalizedStringKey(stringLiteral: "buttonLibrary")) {
                self.showLibrary.toggle()
                // affiche la carte de dos
                if !(image == nil) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.showView = false
                    }
                }
            }
            .buttonStyle(PlainButtonStyle())
            .frame(height: 50)
            .foregroundColor(.white)
            .padding(.horizontal)
            .background(.blue)
            .cornerRadius(10)
            .padding()
            Form {
                Section(LocalizedStringKey(stringLiteral: "rotationSpeed")) {
                    VStack {
                        Slider(value: $speedDuration, in: 1.0...5.0, step: 0.5) {
                            Text(LocalizedStringKey(stringLiteral: "rotationSpeedLabel"))
                        } minimumValueLabel: {
                            Text(LocalizedStringKey(stringLiteral: "rotationMinLabel"))
                                .font(.headline)
                            
                        } maximumValueLabel: {
                            Text(LocalizedStringKey(stringLiteral: "rotationMaxLabel"))
                                .font(.headline)
                        }
                        .padding(.horizontal)
                    }
                }
                    Section(LocalizedStringKey(stringLiteral: "directionOfRotation")) {
                        Toggle(directRotation ? LocalizedStringKey(stringLiteral: "rightleft") : LocalizedStringKey(stringLiteral: "leftright")  ,
                               isOn: $directRotation)
                        .tint(.accentColor)
                    }
                    
                }
                
            
            // ouvrir fenetre sheet
            .sheet(isPresented: $showLibrary) {
                PhotoPicker(image: $inputImage)
            }
            .onChange(of:inputImage) {loadImage()}
        }
    }
    //Chargement Image
    func loadImage() {
        guard let inputImage = inputImage else {return}
        image = Image(uiImage: inputImage)
    }
}

#Preview {
    ContentView()
}


// Transition
// code chaine youtube Kavsoft
//
struct FlipTransition:ViewModifier, Animatable {
    var progress:CGFloat = 0
    var animatableData: CGFloat {
        get {progress}
        set {progress = newValue }
    }
    func body(content: Content) -> some View {
        content
            .opacity(progress < 0 ? (-progress < 0.5 ? 1 : 0) : (progress < 0.5 ? 1 : 0))
            .rotation3DEffect(Angle(degrees: progress * 180),
                              axis: (x: 0.0, y: 1.0, z: 0.0)
            )
    }
}

extension AnyTransition {
    static let flip: AnyTransition = .modifier(
        active: FlipTransition(progress: -1),
        identity: FlipTransition())
    
    
    static let reveseflip: AnyTransition = .modifier(
        active: FlipTransition(progress: 1),
        identity: FlipTransition())

}
//-------------------------------------------------------//
