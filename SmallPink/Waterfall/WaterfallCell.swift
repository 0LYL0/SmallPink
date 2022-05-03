//
//  WaterfallCell.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import UIKit
import LeanCloud
import Kingfisher

class WaterfallCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    var isMyselfLike = false
    
    var likeCount = 0{
        didSet{
            likeBtn.setTitle(likeCount.formattedStr, for: .normal)
        }
    }
    var currentLikeCount = 0
    var isLike: Bool{ likeBtn.isSelected }
    
    var note: LCObject?{
        didSet{
            guard let note = note, let author = note.get(kAuthorCol) as? LCUser else { return }
            
            let coverPhotoURL = note.getImageURL(from: kCoverPhotoCol, .coverPhoto)
            imageView.kf.setImage(with: coverPhotoURL, options: [.transition(.fade(0.2))])

            let avatarURL = author.getImageURL(from: kAvatarCol, .avator)
//            print(avatarURL)
            avatarImageView.kf.setImage(with: avatarURL)
            
            
            //笔记标题
            titleLabel.text = note.getExactStringVal(kTitleCol)
            
            nickNameLabel.text = author.getExactStringVal(kNickNameCol)
            //笔记被赞数量
//            likeBtn.setTitle("\(note.getExactIntVal(kLikeCountCol))", for: .normal)
            likeCount = note.getExactIntVal(kLikeCountCol)
            currentLikeCount = likeCount

            //判断是是否已点赞
            if isMyselfLike{
                likeBtn.isSelected = true
            }else{
                if let user = LCApplication.default.currentUser{
                    let query = LCQuery(className: kUserLikeTable)
                    query.whereKey(kUserCol, .equalTo(user))
                    query.whereKey(kNoteCol, .equalTo(note))
                    query.getFirst{ res in
                        if case .success = res{
                            DispatchQueue.main.async {
                                self.likeBtn.isSelected = true
                            }
                        }
                    }
                }
            }
           
        }
    }
    override func awakeFromNib(){
        super.awakeFromNib()
        let icon = UIImage(systemName: "heart.fill")?.withTintColor(mainColor, renderingMode: .alwaysOriginal)
        likeBtn.setImage(icon, for: .selected)
        
    }
    
    @IBAction func like(_ sender: Any) {
        if let _ = LCApplication.default.currentUser{
            //UI
            likeBtn.isSelected.toggle()
            isLike ? (likeCount += 1) : (likeCount -= 1)
            
            //数据
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
            
           
        }else{
            showGlobalTextHUD("请先登录哦")
        }
        
    }
    
    @objc func likeBtnTappedWhenLogin(){
        if likeCount != currentLikeCount{
            guard let note = note, let authorObjectId = (note.get(kAuthorCol) as? LCUser)?.objectId?.stringValue else { return }
            let user = LCApplication.default.currentUser!
            let offset = isLike ? 1 : -1
            currentLikeCount += offset
            if isLike{
                //userLike中间表
                let userLike = LCObject(className: kUserLikeTable)
                try? userLike.set(kUserCol, value: user)
                try? userLike.set(kNoteCol, value: note)
                userLike.save{ _ in }
                //点赞数
                try? note.increase(kLikeCountCol)
                
                LCObject.userInfo(where: authorObjectId, increase: kLikeCountCol)

            }else{
                //userLike中间表
                let query = LCQuery(className: kUserLikeTable)
                query.whereKey(kUserCol, .equalTo(user))
                query.whereKey(kNoteCol, .equalTo(note))
                query.getFirst{ res in
                    if case let .success(object: userLike) = res{
                        userLike.delete{ _ in }
                    }
                }
                //点赞数
                try? note.set(kLikeCountCol, value: likeCount)
                note.save{ _ in }
                
                LCObject.userInfo(where: authorObjectId, decrease: kLikeCountCol, to: likeCount)

            }
        }
    }
}


