//
//  ReplyCell.swift
//  SmallPink
//
//  Created by yalan on 2022/4/29.
//

import LeanCloud
import Kingfisher

class ReplyCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var replyTextLabel: UILabel!
    @IBOutlet weak var showAllReplyBtn: UIButton!
    
    var reply: LCObject?{
        didSet{
            guard let reply = reply else { return }
            if let user = reply.get(kUserCol) as? LCUser{
                avatarImageView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avator))
                nickNameLabel.text = user.getExactStringVal(kNickNameCol)
            }
//            let replyText = reply.getExactStringVal(kTextCol)
            let createdAt = reply.createdAt?.value
            let dateText = createdAt == nil ? "刚刚" : createdAt!.formatterDate
            let replyText = reply.getExactStringVal(kTextCol).spliceAttrStr(dateText)
            
            if let replyToUser = reply.get(kReplyToUserCol) as? LCUser{
                let replyToText = "回复 ".toAttrStr()
                let nickName = replyToUser.getExactStringVal(kNickNameCol).toAttrStr(14, .secondaryLabel)
                let colon = ": ".toAttrStr()

                replyToText.append(nickName)
                replyToText.append(colon)
                
                replyText.insert(replyToText, at: 0)
            }
            
            replyTextLabel.attributedText = replyText
            

        }
    }
}
