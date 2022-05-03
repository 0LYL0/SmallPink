//
//  NoteDetailVC-PostComment.swift
//  SmallPink
//
//  Created by yalan on 2022/4/29.
//

import LeanCloud
extension NoteDetailVC{
    func postComment(){
        let user = LCApplication.default.currentUser!
        do {
            //云端数据
            let comment = LCObject(className: kCommentTable)
            try comment.set(kTextCol, value: textView.unwrappedText)
            try comment.set(kUserCol, value: user)
            try comment.set(kNoteCol, value: note)
            comment.save{ res in
//                    if case .success = res{
//                        self.showTextHUD("评论已发布")
//                    }
            }
            self.updateCommentCount(by: 1)

            
            //内存数据
            comments.insert(comment, at: 0)
            //UI
//            tableView.reloadData()
            tableView.performBatchUpdates {
                tableView.insertSections(IndexSet(integer: 0), with: .automatic)
            }

        } catch {
            print("给Comment表的字段赋值失败:\(error)")
        }
    }
}
