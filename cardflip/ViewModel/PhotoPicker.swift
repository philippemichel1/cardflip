//
//  PhotoPicker.swift
//  cardflip
//
//  Created by Philippe MICHEL on 20/04/2024.
//

import SwiftUI
import PhotosUI

struct PhotoPicker:UIViewControllerRepresentable {
    @Binding var image:UIImage?
    
    class Coordinator:NSObject, PHPickerViewControllerDelegate {
        var parent:PhotoPicker
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            guard let provider = results.first?.itemProvider else {return}
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    self.parent.image = image as? UIImage
                }
            }
            
        }
    }
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
        
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
}


