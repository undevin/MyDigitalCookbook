//
//  RecipeVisionDetailViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/25/21.
//

import VisionKit

class RecipeVisionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var scanRecipeButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Properties
    var recipe: Recipe?
    
    // MARK: - Actions
    @IBAction func scanButtonTapped(_ sender: UIButton) {
        let scanner = VNDocumentCameraViewController()
        scanner.delegate = self
        present(scanner, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        displaySaveAlertController()
    }
    
    // MARK: - Methods
    func setupViews() {
        scanRecipeButton.layer.cornerRadius = 10
    }
    
    func displaySaveAlertController() {
        let alertController = UIAlertController(title: "Save Scanned Recipe", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Recipe Name"
            textfield.autocapitalizationType = .words
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirm = UIAlertAction(title: "OK", style: .default) { [weak self] (_) in
            guard let name = alertController.textFields?[0].text, !name.isEmpty,
                  let imageData = self?.scanImageView.image?.jpegData(compressionQuality: 0.7) else { return }
            VisionController.shared.createVisionRecipe(name: name, image: imageData)
            self?.navigationController?.popViewController(animated: true)
        }
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        present(alertController, animated: true, completion: nil)
    }
}//End of Class

// MARK: - Extension
extension RecipeVisionViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true) { [weak self] in
            self?.scanImageView.image = scan.imageOfPage(at: 0)
        }
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true) { [weak self] in
            self?.scanImageView.image = nil
            
            let alertController = UIAlertController(title: "Cancelled", message: "User canceled scan", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) { [weak self] in
            self?.scanImageView.image = nil
            
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(action)
            self?.present(alertController, animated: true, completion: nil)
        }
    }
}//End of Extension
