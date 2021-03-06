//
//  ViewController.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-07.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import UIKit
import Firebase
import CoreML
import Vision

@available(iOS 11.0, *)
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var yesButton: ButtonStyleManager!
    @IBOutlet weak var noButton: ButtonStyleManager!
    @IBOutlet weak var correctMatchLabel: UILabel!
   
    var counter = 0
    var correctMatch:Bool!
    
    
    var databaseRef:DatabaseReference! {
        return Database.database().reference()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        self.view.isHidden = true
        textView.isEditable = false
        textView.isSelectable = false
        yesButton.isHidden = true
        noButton.isHidden = true
        correctMatchLabel.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        if counter != 0 {
        self.view.isHidden = false
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if counter == 0 {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(picker, animated: true, completion: nil)
        counter += 1
        }
        
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.view.isHidden = false
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let resNetManager = ResNetManager()
            resNetManager.delegate = self
            let ciImage:CIImage = CIImage(image: image)!
            resNetManager.recognizeImage(image: ciImage)
            SwiftSpinner.show("Loading Matches...")
            imageView.image = image
        }
    }
    
    @IBAction func correctMatch(_ sender: Any) {
        correctMatch = true
        yesButton.isHidden = true
        noButton.isHidden = true
        correctMatchLabel.isHidden = true
        SwiftSpinner.show("Writing to database...")
        uploadImageToStorage()
    }
    
    @IBAction func incorrectMatch(_ sender: Any) {
        correctMatch = false
        yesButton.isHidden = true
        noButton.isHidden = true
        correctMatchLabel.isHidden = true
        SwiftSpinner.show("Writing to database...")
        uploadImageToStorage()
    }
    
    func uploadImageToStorage() {
        
        let imageName = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child(imageName)
        
        if let uploadData = UIImagePNGRepresentation(imageView.image ?? #imageLiteral(resourceName: "Tom's_Restaurant,_NYC")) {
            storageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "error")
                    SwiftSpinner.hide()
                    return
                }
                let imageURL = metadata?.downloadURL()?.absoluteString
                self.writeToDatabase(imageURL: imageURL!)
            })
            
        }
    }
    
    func writeToDatabase(imageURL:String) {
        
        let queryRef = databaseRef.child("Queries").child(imageURL.replacingOccurrences(of: ".", with: "dot").replacingOccurrences(of: "/", with: "slash"))
        
        let query = Query(user: (Auth.auth().currentUser?.email)!, imageURL: imageURL, matches: self.textView.text.replacingOccurrences(of: "\n", with: ","), correctMatch: correctMatch)
        
        queryRef.setValue(query.toAnyObject())

        SwiftSpinner.hide()
    }
    
  

    @IBAction func goBackToCamera(_ sender: UIBarButtonItem) {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func logOut(_ sender:UIBarButtonItem) {
        if Auth.auth().currentUser != nil {
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("Error signing out: %@", signOutError.localizedDescription)
            }
            self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true, completion: nil)
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "navigationController")
            self.present(viewController!, animated: true, completion: nil)
        }
    }
}

@available(iOS 11.0, *)
extension ViewController: ResNetManagerDelegate {
    
    func updateTextViewWithMatches(matches: Array<String>) {
        SwiftSpinner.hide()
        let topFiveMatchesArray = matches.prefix(upTo: 5)
        var topFiveMatchesArrayWithoutDoubles:Array<String> = []
        var matchComponents:Array<String> = []
        for match in topFiveMatchesArray {
            matchComponents = match.components(separatedBy: ",")
            topFiveMatchesArrayWithoutDoubles.append(matchComponents[0])
        }
        let matchesArrayWithoutQuotations = String(format: "%@", topFiveMatchesArrayWithoutDoubles.description.replacingOccurrences(of: "\"", with: "", options: NSString.CompareOptions.literal, range:nil))
        let formattedMatchesArray = matchesArrayWithoutQuotations.trimmingCharacters(in: CharacterSet.punctuationCharacters).replacingOccurrences(of: ",", with: "\n")
        let space = " "
        self.textView.text = space.appending(formattedMatchesArray)
        yesButton.isHidden = false
        noButton.isHidden = false
        correctMatchLabel.isHidden = false
    }
}
