//
//  NoteDetailVC-LikeFav.swift
//  SmallPink
//
//  Created by yalan on 2022/4/26.
//

import Foundation
import LeanCloud
extension NoteDetailVC{
    func like(){
        if let user = LCApplication.default.currentUser{
            //UI
            isLike ? (likeCount += 1) : (likeCount -= 1)
            //数据
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(likeBtnTappedWhenLogin), object: nil)
            perform(#selector(likeBtnTappedWhenLogin), with: nil, afterDelay: 1)
   
        }else{
            showLoginHUD()
        }
    }
    
    @objc private func likeBtnTappedWhenLogin(){
        if likeCount != currentLikeCount{
            let user = LCApplication.default.currentUser!
            let authorObjectId = author?.objectId?.stringValue ?? ""
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
                
//                try? author?.increase(kLikeCountCol)
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
//                try? author?.set(kLikeCountCol, value: likeCount)
//                author?.save{ _ in }
                LCObject.userInfo(where: authorObjectId, decrease: kLikeCountCol, to: likeCount)
            }
        }
    }
    
   
}
