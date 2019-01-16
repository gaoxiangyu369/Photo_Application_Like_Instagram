//
//  Brightness.swift
//  MyInstagram
//
//  Created by Liang Zhang on 13/10/18.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class Brightness: UIViewController {
    
    var blankImage: UIImage?
    @IBOutlet weak var brightnessSlider: UISlider!
    @IBOutlet weak var contrastSlider: UISlider!
    
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var colorControlsFilter : CIFilter!
    fileprivate var ciImageContext: CIContext!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = blankImage
        let openGLContext = EAGLContext(api: .openGLES3)!
        ciImageContext = CIContext(eaglContext: openGLContext)
        colorControlsFilter = CIFilter(name: "CIColorControls")!
        
        if let cgimg = blankImage!.cgImage {
            let coreImage = CIImage(cgImage: cgimg)
            self.colorControlsFilter.setValue(coreImage, forKey: kCIInputImageKey)
        }
        
        self.setDefaultValueOfSliders()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"Done", style: .plain, target:self, action:#selector(doneAction))
        // Do any additional setup after loading the view.
    }
    
    
    @objc func cancelAction (){
        let photoView : UIViewController = UIStoryboard(name: "Add", bundle: nil).instantiateViewController(withIdentifier: "PhotoViewController")
        self.present(photoView, animated: true, completion: nil)
    }
    
    @objc func doneAction (){
        //        self.performSegue(withIdentifier: "UploadViewController", sender: self.blankImage)
        if let uploadView = self.storyboard?.instantiateViewController(withIdentifier: "UploadViewController") as? UploadViewController {
            uploadView.selectedImage = self.blankImage
            self.navigationController!.pushViewController(uploadView, animated: true)
        }
    }
    
    @IBAction func contrastSliderPressed(_ sender: UISlider) {
        colorControlsFilter.setValue(sender.value, forKey: kCIInputContrastKey)
        
        if let outputImage = self.colorControlsFilter.outputImage {
            if let cgImageNew = self.ciImageContext.createCGImage(outputImage, from: outputImage.extent) {
                let newImg = UIImage(cgImage: cgImageNew)
                imageView.image = newImg
            }
        }
    }
    @IBAction func brightnessSliderPressed(_ sender: UISlider) {
        
        colorControlsFilter.setValue(sender.value, forKey: kCIInputBrightnessKey)
        if let outputImage = self.colorControlsFilter.outputImage {
            if let cgImageNew = self.ciImageContext.createCGImage(outputImage, from: outputImage.extent) {
                let newImg = UIImage(cgImage: cgImageNew)
                imageView.image = newImg
            }
        }
    }
    
    
    func setDefaultValueOfSliders() {
        colorControlsFilter.setDefaults()
        let brightnessValue = self.colorControlsFilter.value(forKey: kCIInputBrightnessKey) as? Float
        let contrastValue = self.colorControlsFilter.value(forKey: kCIInputContrastKey) as? Float
        
        contrastSlider.value = contrastValue ?? 1.00
        contrastSlider.maximumValue = 4.00
        contrastSlider.minimumValue = 0.00
        
        brightnessSlider.value = brightnessValue ?? 0.0
        brightnessSlider.maximumValue = 1.00
        brightnessSlider.minimumValue = -1.00
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
