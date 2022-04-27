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
            
            if isLike{
                //userLike中间表
                let userLike = LCObject(className: kUserLikeTable)
                try? userLike.set(kUserCol, value: user)
                try? userLike.set(kNoteCol, value: note)
                userLike.save{ _ in }
                //点赞数
                try? note.increase(kLikeCountCol)
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
            }
           
        }else{
            showTextHUD("请先登录哦")
        }
    }
    func fav(){
        if let user = LCApplication.default.currentUser{
            
        }else{
            showTextHUD("请先登录哦")
        }
    }
}
