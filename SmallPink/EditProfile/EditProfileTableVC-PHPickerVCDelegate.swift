//
//  EditProfileTableVC-PHPickerVCDelegate.swift
//  SmallPink
//
//  Created by yalan on 2022/5/4.
//

import PhotosUI
extension EditProfileTableVC: PHPickerViewControllerDelegate{
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
//        let itemProviders = results.map(\.itemProvider)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider, itemProvider.canLoadObject(ofClass: UIImage.self){
            itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                guard let self = self, let image = image as? UIImage else {
                    return
                }
               self.avatar = image

            }
        }
    }
}
