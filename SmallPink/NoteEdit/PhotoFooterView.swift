//
//  PhotoFooterView.swift
//  SmallPink
//
//  Created by yalan on 2022/4/11.
//

import UIKit

class PhotoFooterView: UICollectionReusableView {
        
    @IBOutlet weak var addPhotoBtn: UIButton!
    
    override func awakeFromNib() {
        addPhotoBtn.layer.borderWidth = 1
        addPhotoBtn.layer.borderColor = UIColor.quaternaryLabel.cgColor
    }
}
