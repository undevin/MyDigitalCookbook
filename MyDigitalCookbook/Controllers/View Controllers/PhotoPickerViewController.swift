//
//  PhotoPickerViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/24/21.
//

import UIKit

// MARK: - Protocols
protocol PhotoSelectorDelegate: AnyObject {
    func photoPickerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var selectPhotoButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Properties
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoSelectorDelegate?
    
    // MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add a Photo", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Methods
    func setupViews() {
        photoImageView.contentMode = .center
        photoImageView.clipsToBounds = true
        selectPhotoButton.setTitle("Add an Image", for: .normal)
        imagePicker.delegate = self
    }
    
}//End of Class

// MARK: - Extensions
extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No Camera Access", message: "Please allow access to your camera", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No Photo Library Access", message: "Please allow access to your photo library", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            guard let delegate = delegate else { return }
            delegate.photoPickerSelected(image: pickedImage)
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
        photoImageView.contentMode = .scaleAspectFill
    }
}//End of Extension
