//
//  ViewController.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-07.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var button: UIButton!
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.view.isHidden = true
        textView.isEditable = false
        textView.isSelectable = false
    }

    override func viewWillAppear(_ animated: Bool) {
        if counter != 0 {
        self.view.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if counter == 0 {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        present(picker, animated: true, completion: nil)
        counter += 1
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.view.isHidden = false
        
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let apiManager = APIManager()
            apiManager.delegate = self
            apiManager.recognizeImage(image: image)
            SwiftSpinner.show("Loading Matches...")
            imageView.image = image
            button.isEnabled = false
        }
    }

    @IBAction func goBackToCamera(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
}

extension ViewController: APIManagerDelegate {
    
    func updateTextViewWithMatches(matches: Array<String>) {
        SwiftSpinner.hide()
        let topFiveMatchesArray = matches.prefix(upTo: 5)
        let matchesArrayWithoutQuotations = String(format: "%@", topFiveMatchesArray.description.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil))
        
        let formattedMatchesArray = matchesArrayWithoutQuotations.trimmingCharacters(in: CharacterSet.punctuationCharacters).replacingOccurrences(of: ",", with: "\n")
        let space = " "
        self.textView.text = space.appending(formattedMatchesArray)
        
        self.button.isEnabled = true
        
    }
}
