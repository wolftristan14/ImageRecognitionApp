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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        imageView.isHidden = true
        textView.isHidden = true
        button.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewDidAppear(_ animated: Bool) {
        
        if imageView.image == nil {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: false, completion: nil)
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The user picked an image. Send it to Clarifai for recognition.
        imageView.isHidden = false
        textView.isHidden = false
        button.isHidden = false
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let apiManager = APIManager()
            apiManager.delegate = self
            apiManager.recognizeImage(image: image)
            imageView.image = image
            textView.text = "Loading..."
            button.isEnabled = false
        }
    }

    
    @IBAction func goBackToCamera(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        present(picker, animated: false, completion: nil)
    }
    
}

extension ViewController: APIManagerDelegate {
    
    func sendAnswersArrayToViewController(answers: Array<String>) {
        self.textView.text = String(format: "Answers:\n%@", answers.description)
        self.button.isEnabled = true
        
    }
}
