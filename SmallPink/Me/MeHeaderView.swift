//
//  MeHeaderView.swift
//  SmallPink
//
//  Created by yalan on 2022/5/2.
//

import LeanCloud
import Kingfisher

class MeHeaderView: UIView {

    @IBOutlet weak var rootStackView: UIStackView!
    @IBOutlet weak var editOrFollowBtn: UIButton!
    
    @IBOutlet weak var settingOrChatBtn: UIButton!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var likeAndFavedLabel: UILabel!
    @IBOutlet weak var backOrSlideBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        editOrFollowBtn.makeCapsule()
        settingOrChatBtn.makeCapsule()
    }
    var user: LCUser!{
        didSet{
            avatarImageView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avator))
            nickNameLabel.text = user.getExactStringVal(kNickNameCol)
            
            let gender = user.getExactBoolValDefaultF(kGenderCol)
            genderLabel.text = gender ? "♂︎" : "♀︎"
            genderLabel.textColor = gender ? blueColor : mainColor
            
            idLabel.text = "\(user.getExactIntVal(kIDCol))"
            
            let intro = user.getExactStringVal(kIntroCol)
            introLabel.text = intro.isEmpty ? kIntroPH : intro
            
            guard let userObjectId = user.objectId?.stringValue else { return }
            let query = LCQuery(className: kUserInfoTable)
            query.whereKey(kUserObjectIdCol, .equalTo(userObjectId))
            query.getFirst { res in
                if case let .success(object: userInfo) = res{
                    let likeCount = userInfo.getExactIntVal(kLikeCountCol)
                    let favCount = userInfo.getExactIntVal(kFavCountCol)
                    DispatchQueue.main.async {
                        self.likeAndFavedLabel.text = "\(likeCount + favCount)"
                    }
                }
            }
        }
    }
   
}
