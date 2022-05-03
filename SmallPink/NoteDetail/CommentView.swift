//
//  CommentView.swift
//  SmallPink
//
//  Created by yalan on 2022/4/28.
//

import UIKit
import LeanCloud
import Kingfisher

class CommentView: UITableViewHeaderFooterView {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var commentTextLabel: UILabel!
    var comment: LCObject?{
        didSet{
            guard let comment = comment else { return }
            if let user = comment.get(kUserCol) as? LCUser{
                avatarImageView.kf.setImage(with: user.getImageURL(from: kAuthorCol, .avator))
                nickNameLabel.text = user.getExactStringVal(kNickNameCol)
            }
            let commentText = comment.getExactStringVal(kTextCol)
            let createdAt = comment.createdAt?.value
            let dateText = createdAt == nil ? "刚刚" : createdAt!.formatterDate
            
            commentTextLabel.attributedText = commentText.spliceAttrStr(dateText)

        }
    }

}
