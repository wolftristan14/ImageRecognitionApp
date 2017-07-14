//
//  ResNetManager.swift
//  ImageRecognitionApp
//
//  Created by Tristan Wolf on 2017-07-14.
//  Copyright © 2017 Tristan Wolf. All rights reserved.
//

import CoreML
import Vision

protocol ResNetManagerDelegate {
    @available(iOS 11.0, *)
    func updateTextViewWithMatches(matches:Array<String>)
}

@available(iOS 11.0, *)
class ResNetManager: NSObject {
    
    var matches = Array<String>()
    var delegate:ResNetManagerDelegate?
    
    func recognizeImage(image: CIImage) {
        let resNetModel = Resnet50.init()
        guard let model = try? VNCoreMLModel(for: resNetModel.model) else {
            fatalError("can't load Places ML model")
        }
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("unexpected result type from VNCoreMLRequest")
            }
            for result in results {
                self.matches.append(result.identifier)
            }
            DispatchQueue.main.async {
                self.delegate?.updateTextViewWithMatches(matches: self.matches)
            }
        }
        let handler = VNImageRequestHandler(ciImage: image)
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try handler.perform([request])
            } catch {
                print(error)
                SwiftSpinner.hide()
            }
        }
    }
}
