//
//  ViewController.swift
//  classifer_example
//
//  Created by jay on 8/25/19.
//  Copyright © 2019 jay. All rights reserved.
//

import UIKit
import Vision
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var confidence: UILabel!
    @IBOutlet weak var imageDisplayer: UIImageView!
    
    var picker = UIImagePickerController()
    
    func imageProcess(image: UIImage)
    {
    if let model = try? VNCoreMLModel(for: ImageClassifer().model) {
        let request = VNCoreMLRequest(model: model) { (request, error) in
            var temp:VNClassificationObservation?
            if let results = request.results as? [VNClassificationObservation] {
                for result in results {
                    print("\(result.identifier): \(result.confidence    3)")
                    if ((temp == nil) || temp!.confidence < result.confidence)
                    {
                      temp = result
                    }
                    
                }
            }
                    //print("\(result.identifier): \(result.confidence * 100)%")
            self.number.text = temp?.identifier
            let val = temp?.confidence ?? 0.0
            self.confidence.text = "\(val*100.0 ) %"
            }
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let handler = VNImageRequestHandler(data: imageData, options: [:])
            try? handler.perform([request])
            }
    }
        
    
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
        imageDisplayer.image = image
        imageProcess(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any) {
    picker.sourceType = .camera
    present(picker, animated: true, completion: nil)
    }
    
    @IBAction func selectImage(_ sender: Any) {
    picker.sourceType = .photoLibrary
    present(picker,animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        picker.delegate = self
    }

    
}

