//
//  DraftNoteWaterfallCell.swift
//  SmallPink
//
//  Created by yalan on 2022/4/14.
//

import UIKit

class DraftNoteWaterfallCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var isVideoImageView: UIImageView!
    
    var draftNote: DraftNote? {
        didSet{
            guard let draftNote = draftNote else {
                return
            }
            imageView.image = UIImage(draftNote.coverPhoto) ?? imagePH
            
            let title = draftNote.title!
            titleLabel.text = title.isEmpty ? "无题" : title
            
            dateLabel.text = draftNote.updateAt?.formatterDate

            isVideoImageView.isHidden = !draftNote.isVideo
        }
    }
}
