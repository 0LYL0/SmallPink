//
//  NoteDetailVC-Helper.swift
//  SmallPink
//
//  Created by yalan on 2022/4/27.
//

import Foundation
import UIKit
import LeanCloud
extension NoteDetailVC{
    func comment(){
        if let _ = LCApplication.default.currentUser{
            
            showTextView()
        }else{
            showLoginHUD()
        }
    }
    func prepareForReply(_ nikeName: String, _ section: Int, _ replyToUser: LCUser? = nil){
        showTextView(true, "回复 \(nikeName)", replyToUser)
        commentSection = section
    }
    func showTextView(_ isReply: Bool = false, _ textViewPH: String = kNoteCommentPH, _ replyToUser: LCUser? = nil){
        //reset
        self.isReply = isReply
        textView.placeholder = textViewPH
        self.replyToUser = replyToUser
        
        //UI
        textView.becomeFirstResponder()
        textViewBarView.isHidden = false
    }
    
    func hideAndResetTextView(){
        textView.resignFirstResponder()
        textView.text = ""
        
    }
    
}
extension NoteDetailVC{
    func showDelAlert(for name: String, confirmHandler: ((UIAlertAction) -> ())?){
        let alert = UIAlertController(title: "提示", message: "确认删除此\(name)", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let action2 = UIAlertAction(title: "确认", style: .default, handler: confirmHandler)
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert,animated: true, completion: nil)
    }
    
    func updateCommentCount(by offset: Int){
        try? self.note.increase(kCommentCountCol, by: offset)
        note.save { _ in }
        
        self.commentCount -= 1
    }
   
}
