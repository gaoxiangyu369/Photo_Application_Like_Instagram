//
//  PhotoCollectionViewCell.swift
//  MyInstagram
//
//  Created by Jocelyn Jiang on 14/10/2018.
//  Copyright © 2018 Jocelyn Jiang. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
        if let photoUrlStr = post?.photoUrl {
            let photoUrl = URL(string: photoUrlStr)
            photoView.sd_setImage(with: photoUrl)
        }
    }
    
}
