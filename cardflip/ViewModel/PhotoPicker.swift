//
//  PhotoPicker.swift
//  cardflip
//
//  Created by Philippe MICHEL on 20/04/2024.
//

import SwiftUI
import PhotosUI

// Définition d'une structure PhotoPicker qui se conforme au protocole UIViewControllerRepresentable
struct PhotoPicker:UIViewControllerRepresentable {
    @Binding var image:UIImage?
    
    // Définition d'une classe Coordinator pour gérer les interactions avec PHPickerViewController
    class Coordinator:NSObject, PHPickerViewControllerDelegate {
        var parent:PhotoPicker
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        // Fonction appelée lorsque la sélection d'images est terminée dans PHPickerViewController
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // Dismiss du PHPickerViewController
            picker.dismiss(animated: true)
            
            // on récupère le premier résultat de la séléction
            guard let provider = results.first?.itemProvider else {return}
            // Vérifie si le provider peut charger un objet de type UIImage
            if provider.canLoadObject(ofClass: UIImage.self) {
                
                // Charge l'objet de type UIImage à partir du provider
                provider.loadObject(ofClass: UIImage.self) { picture, _ in
                    //place l'image de type UIImage (image de la selection)
                    self.parent.image = picture as? UIImage
                }
            }
            
        }
    }
    // Fonction pour créer une instance de PHPickerViewController
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        // Configuration de PHPickerViewController pour filtrer et sélectionner uniquement des images
        var config = PHPickerConfiguration()
        config.filter = .images
        
        // Création d'une instance de PHPickerViewController avec la configuration définie
        let picker = PHPickerViewController(configuration: config)
        // Attribution du délégué (Coordinator) au PHPickerViewController
        picker.delegate = context.coordinator
        return picker
        
    }
    // Fonction appelée lorsqu'une mise à jour de l'interface utilisateur est nécessaire
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        // pas utilisé ici mais cette fonction doit être présente pour se conformer au protocole
        
    }
    
    // Fonction pour créer une instance de Coordinator et la lier à la structure PhotoPicker
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    
}


