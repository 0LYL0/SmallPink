//
//  NoteDetailVC-UI.swift
//  SmallPink
//
//  Created by yalan on 2022/4/24.
//

import Foundation
import Kingfisher
import LeanCloud
import ImageSlideshow
import UIKit

extension NoteDetailVC{
    func setUI(){
        followBtn.makeCapsule(mainColor)
//        followBtn.layer.borderWidth = 1
//        followBtn.layer.borderColor = mainColor.cgColor
        
        if isReadMyNote{
            followBtn.isHidden = true
            shareOrMoreBtn.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        }
        
        showNote()
        showLike()
    }
    func showNote(_ isUpdatingNote: Bool = false){
        if !isUpdatingNote{
            let authorAvatarURL = author?.getImageURL(from: kAvatarCol, .avator)
            authorAvatarBtn.kf.setImage(with: authorAvatarURL, for: .normal)
            authorNikeNameBtn.setTitle(author?.getExactStringVal(kNickNameCol), for: .normal)
        }
        //note图片
        let coverPhotoHeight = CGFloat(note.getExactDoubleVal(kCoverPhotoRatioCol)) * screenRect.width
        imageSlideshowHeight.constant = coverPhotoHeight
        
        let coverPhoto = KingfisherSource(url: note.getImageURL(from: kCoverPhotoCol, .coverPhoto))
        if let photoPaths = note.get(kPhotosCol)?.arrayValue as? [String]{
            var photoArr = photoPaths.compactMap{ KingfisherSource(urlString: $0) }
            photoArr[0] = coverPhoto
            imageSlideshow.setImageInputs(photoArr)
        }else{
            imageSlideshow.setImageInputs([coverPhoto])
        }
        
        //标题
        let noteTitle = note.getExactStringVal(kTitleCol)
        if noteTitle.isEmpty{
            titleLabel.isHidden = true
        }else{
            titleLabel.text = noteTitle
        }
        
        let noteText = note.getExactStringVal(kTextCol)
        if noteText.isEmpty{
            textLabel.isHidden = true
        }else{
            textLabel.text = noteText
        }
        
        //note话题
        let noteChannel = note.getExactStringVal(kChannelCol)
        let noteSubChannel = note.getExactStringVal(kSubChannelCol)
        channelBtn.setTitle(noteSubChannel.isEmpty ? noteChannel : noteSubChannel, for: .normal)
        
        //note发表或编辑时间
        if let updatedAt = note.updatedAt?.value{
            dateLabel.text = "\(note.getExactBoolValDefaultF(kHasEditCol) ? "编辑于 " : "")\(updatedAt.formatterDate)"
        }
        
        //当前用户头像
        if let user = LCApplication.default.currentUser{
            let avatarURL = user.getImageURL(from: kAvatarCol, .avator)
            avatarImageView.kf.setImage(with: avatarURL)
        }
        
        //点赞数
        likeCount = note.getExactIntVal(kLikeCountCol)
        currentLikeCount = likeCount
        
        favCount = note.getExactIntVal(kFavCountCol)
        currentFavCount = favCount
        
        commentCount = note.getExactIntVal(kCommentCountCol)
        
    }
    private func showLike(){
        likeBtn.setSelected(selected: isLikeFromWaterfallCell, animated: false)
    }
}
