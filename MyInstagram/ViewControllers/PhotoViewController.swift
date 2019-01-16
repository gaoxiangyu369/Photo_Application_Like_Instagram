//
//  PhotoViewController.swift
//  MyInstagram
//
//  Created by Liang Zhang on 01/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit
import Stevia
import YPImagePicker
import Photos



class PhotoViewController: UIViewController {
    
    var selectedItems = [YPMediaItem]()
    var image : UIImage?
    
    override func viewWillAppear(_ animated: Bool) {
        if image == nil {
            showPicker()
        }
    }
    
    @objc
    func showPicker() {
        
        var config = YPImagePickerConfiguration()
        
        config.library.mediaType = .photo
        config.shouldSaveNewPicturesToAlbum = false
        config.startOnScreen = .library
        config.screens = [.library, .photo]
        config.showsCrop = .rectangle(ratio: 1/1.0)
        
        /* Defines the overlay view for the camera. Defaults to UIView(). */
        let grid = GridView()
        grid.alpha = 0.5
        config.overlayView = grid
        
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        
        let picker = YPImagePicker(configuration: config)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                self.selectedItems = [YPMediaItem]()
                self.image = nil
                
                let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarId")
                self.present(home, animated: true, completion: nil)
                return
            }
            self.selectedItems = items
            self.image = (items.singlePhoto?.image)!
            picker.dismiss(animated: false, completion:nil)
            if let uploadView = self.storyboard?.instantiateViewController(withIdentifier: "Upload") as? Brightness {
                uploadView.blankImage = self.image
                self.navigationController!.pushViewController(uploadView, animated: true)
            }
        }
        present(picker, animated: true, completion: nil)
    }
}



class GridView: UIView {
    
    let line1 = UIView()
    let line2 = UIView()
    let line3 = UIView()
    let line4 = UIView()
    
    convenience init() {
        self.init(frame: .zero)
        isUserInteractionEnabled = false
        sv(
            line1,
            line2,
            line3,
            line4
        )
        
        let stroke: CGFloat = 0.7
        line1.top(0).width(stroke).bottom(0)
        line1.Right == 33 % Right
        
        line2.top(0).width(stroke).bottom(0)
        line2.Right == 66 % Right
        
        line3.left(0).height(stroke).right(0)
        line3.Bottom == 33 % Bottom
        
        line4.left(0).height(stroke).right(0)
        line4.Bottom == 66 % Bottom
        
        let color = UIColor.white.withAlphaComponent(1)
        line1.backgroundColor = color
        line2.backgroundColor = color
        line3.backgroundColor = color
        line4.backgroundColor = color
        
        applyShadow(to: line1)
        applyShadow(to: line2)
        applyShadow(to: line3)
        applyShadow(to: line4)
    }
    
    func applyShadow(to view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 2
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
