//
//  NoteDetailVC-Fav.swift
//  SmallPink
//
//  Created by yalan on 2022/4/26.
//

import LeanCloud
extension NoteDetailVC{
    func fav(){
        if let user = LCApplication.default.currentUser{
            //UI
            isFav ? (favCount += 1) : (favCount -= 1)
            //数据
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(favBtnTappedWhenLogin), object: nil)
            perform(#selector(favBtnTappedWhenLogin), with: nil, afterDelay: 1)
        }else{
            showLoginHUD()
        }
    }
    @objc private func favBtnTappedWhenLogin(){
        if favCount != currentFavCount{
            let user = LCApplication.default.currentUser!
            let authorObjectId = author?.objectId?.stringValue ?? ""
            let offset = isFav ? 1 : -1
            currentFavCount += offset
            if isFav{
                //userLike中间表
                let userFav = LCObject(className: kUserFavTable)
                try? userFav.set(kUserCol, value: user)
                try? userFav.set(kNoteCol, value: note)
                userFav.save{ _ in }
                //点赞数
                try? note.increase(kFavCountCol)
                
                LCObject.userInfo(where: authorObjectId, increase: kFavCountCol)
//                try? author?.increase(kLikeCountCol)
            }else{
                //userLike中间表
                let query = LCQuery(className: kUserFavTable)
                query.whereKey(kUserCol, .equalTo(user))
                query.whereKey(kNoteCol, .equalTo(note))
                query.getFirst{ res in
                    if case let .success(object: userFav) = res{
                        userFav.delete{ _ in }
                    }
                }
                //点赞数
                try? note.set(kFavCountCol, value: favCount)
                note.save{ _ in }
//                try? author?.set(kLikeCountCol, value: likeCount)
//                author?.save{ _ in }
                LCObject.userInfo(where: authorObjectId, decrease: kFavCountCol, to: favCount)
            }
        }
 }
}
