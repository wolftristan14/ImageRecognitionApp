//
//  APIManager.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-07.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import Clarifai

protocol APIManagerDelegate {
    func updateTextViewWithAnswers(answers:Array<String>)
}


class APIManager: NSObject {
    
    let app = ClarifaiApp(apiKey: "e61a45b0c24f42528b9de709b83cc3d2")
    var answers = Array<String>()
    
    var delegate:APIManagerDelegate?
    

    func recognizeImage(image: UIImage) {
        
        if let app = app {
            
            app.getModelByName("general-v1.3", completion: { (model, error) in
                
                let clarImage = ClarifaiImage(image: image)!
                
                model?.predict(on: [clarImage], completion: { (outputs, error) in
                    print(error?.localizedDescription ?? "no error")
                    guard
                        let clarOuputs = outputs
                        else {
                            print("Recognition task failed")
                            return
                    }
                    
                    if let clarOutput = clarOuputs.first {
                        for concept in clarOutput.concepts {
                            self.answers.append(concept.conceptName)
                        }
                        
                        DispatchQueue.main.async {
                            self.delegate?.updateTextViewWithAnswers(answers: self.answers)
                        }
                    }
                })
            })
        }
    }
   
    

    
 
}
