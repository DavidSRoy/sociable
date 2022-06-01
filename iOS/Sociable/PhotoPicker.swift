//
//  PhotoPicker.swift
//  Sociable
//
//  Created by 0xMango on 4/26/22.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    @Binding var imageUrlString: String
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true     // figure out how to overlay circle
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let photoPicker: PhotoPicker
        @ObservedObject var vm = MainMessagesViewModel()
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let imageUrl = info[.imageURL] as? URL else {
                return
            }
            
            photoPicker.imageUrlString = imageUrl.path

//
//            do {
//                let tempDirectory = URL(fileURLWithPath: NSTemporaryDirectory())
//                    .appendingPathComponent("uploads")
//                
//                try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true, attributes: nil)
//                
//                let fileURL = tempDirectory
//                    .appendingPathComponent(UUID().uuidString)
//                    .appendingPathComponent(imageUrl.pathExtension)
//                
//                try FileManager.default.copyItem(at: imageUrl, to: fileURL)
//                
//                // when done, clean up (presumably in the completion handler of the async upload routine)
//                // FileManager.default.removeItem(at: fileURL)
//            } catch {
//                print(error)
//            }
            picker.dismiss(animated: true)
        }
    }
}

