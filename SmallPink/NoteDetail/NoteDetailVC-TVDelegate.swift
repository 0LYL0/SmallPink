//
//  NoteDetailVC-TVDelegate.swift
//  SmallPink
//
//  Created by yalan on 2022/4/28.
//

import Foundation
import UIKit
import LeanCloud
extension NoteDetailVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let commentView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentViewID) as! CommentView
        let comment = comments[section]
        let commentAuthor = comment.get(kUserCol) as? LCUser
        commentView.comment = comment
        
        //判断评论人是否是笔记作者
        if let commentAuthor = commentAuthor, let noteAuthor = author, commentAuthor == noteAuthor{
            commentView.authorLabel.isHidden = false
        }else{
            commentView.authorLabel.isHidden = true
        }
        //轻触评论
        let commentTap = UITapGestureRecognizer(target: self, action: #selector(commentTapped))
        commentView.tag = section
        commentView.addGestureRecognizer(commentTap)
        
        let avatarTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        avatarTap.passObj = commentAuthor
        commentView.avatarImageView.addGestureRecognizer(avatarTap)
        
        let nickNameTap = UIPassableTapGestureRecognizer(target: self, action: #selector(goToMeVC))
        nickNameTap.passObj = commentAuthor
        commentView.nickNameLabel.addGestureRecognizer(nickNameTap)
        
        return commentView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let separatorLine = tableView.dequeueReusableHeaderFooterView(withIdentifier: kCommentSectionFooterViewID)
        return separatorLine
    }
    //用户按下评论的回复cell后,对这个回复进行复制删除或再回复
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let user = LCApplication.default.currentUser{
            let reply = replies[indexPath.section].replies[indexPath.row]
            guard let replyAuthor = reply.get(kUserCol) as? LCUser else { return }
            let replyAuthorNikeName = replyAuthor.getExactStringVal(kNickNameCol)
            
            //当前用户点击自己发布的回复
            if replyAuthor == user{
                let replyText = reply.getExactStringVal(kTextCol)
                
                let alert = UIAlertController(title: nil, message: "你的回复: \(replyText)", preferredStyle: .actionSheet)
                let subReplyAction = UIAlertAction(title: "回复", style: .default){ _ in
                    //回复
                    self.prepareForReply(replyAuthorNikeName, indexPath.section, self.replyToUser)
                }
                let copyAction = UIAlertAction(title: "复制", style: .default){ _ in
                    UIPasteboard.general.string = replyText
                }
                let deleteAction = UIAlertAction(title: "删除", style: .destructive){ _ in
                    self.delReply(reply, indexPath)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                    
                }
                alert.addAction(subReplyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                present(alert,animated: true, completion: nil)
            }else{//当前用户点击别人发布的回复
                self.prepareForReply(replyAuthorNikeName, indexPath.section, self.replyToUser)
            }
        }else{
            showLoginHUD()
        }
    }
}

extension NoteDetailVC{
    @objc private func commentTapped(_ tap: UITapGestureRecognizer){
        if let user = LCApplication.default.currentUser{
            guard let section = tap.view?.tag else { return }
            let comment = comments[section]
            guard let commentAuthor = comment.get(kUserCol) as? LCUser else { return }
            let commentAuthorNikeName = commentAuthor.getExactStringVal(kNickNameCol)
            //当前登录用户点击自己发布的评论
            if commentAuthor == user{
                let commentText = comment.getExactStringVal(kTextCol)
                let alert = UIAlertController(title: nil, message: "你的评论: \(commentText)", preferredStyle: .actionSheet)
                let replyAction = UIAlertAction(title: "回复", style: .default){ _ in
                    //回复
                    self.prepareForReply(commentAuthorNikeName, section)
                }
//                replyAction.setTitleColor(mainColor)
                let copyAction = UIAlertAction(title: "复制", style: .default){ _ in
                    UIPasteboard.general.string = commentText
                }
                let deleteAction = UIAlertAction(title: "删除", style: .destructive){ _ in
                    self.delComment(comment, section)
                }
                let cancelAction = UIAlertAction(title: "取消", style: .cancel) { _ in
                    
                }
                alert.addAction(replyAction)
                alert.addAction(copyAction)
                alert.addAction(deleteAction)
                alert.addAction(cancelAction)
                present(alert,animated: true, completion: nil)
                
            }else{//当前登录用户点击别人发布的评论
               //回复
                prepareForReply(commentAuthorNikeName, section)
            }
        }else{
            showLoginHUD()
        }
    }
}
