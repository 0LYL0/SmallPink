//
//  NoteDetailVC-DelComment.swift
//  SmallPink
//
//  Created by yalan on 2022/4/28.
//

import LeanCloud
extension NoteDetailVC{
    func delComment(_ comment: LCObject, _ section: Int){
        self.showDelAlert(for: "评论") { _ in
            //云端数据
            comment.delete{ _ in }
            self.updateCommentCount(by: -1)
            //内存数据
            self.comments.remove(at: section)
            //UI
            self.tableView.reloadData()
        
        }
    }
}
