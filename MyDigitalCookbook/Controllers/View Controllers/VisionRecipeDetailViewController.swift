//
//  RecipeVisionDetailViewController.swift
//  MyDigitalCookbook
//
//  Created by Devin Flora on 2/26/21.
//

import UIKit

class VisionRecipeDetailViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var imageScrollView: UIScrollView!
    
    @IBOutlet weak var visionRecipeNameLabel: UILabel!
    @IBOutlet weak var visionRecipeImageView: UIImageView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Properties
    var visionRecipe: Vision? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var tapGesture: UITapGestureRecognizer!
    
    // MARK: - Methods
    func updateViews() {
        guard let visionRecipe = visionRecipe,
              let image = visionRecipe.image else { return }
        visionRecipeNameLabel.text = visionRecipe.name
        visionRecipeImageView.image = UIImage(data: image)
        imageScrollView.delegate = self
        imageScrollView.minimumZoomScale = 1.0
        imageScrollView.maximumZoomScale = 10.0
    }
    
    func setupGestureRecognizer() {
        tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        tapGesture.numberOfTapsRequired = 2
    }
    
}//End of Class

// MARK: - Extensions
extension VisionRecipeDetailViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return visionRecipeImageView
    }
}//End of Extension
