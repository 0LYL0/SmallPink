//
//  MyDraftNoteWaterfallCell.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import UIKit

class MyDraftNoteWaterfallCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        countLabel.text = "\(UserDefaults.standard.integer(forKey: kDraftNoteCount))"
    }

}
