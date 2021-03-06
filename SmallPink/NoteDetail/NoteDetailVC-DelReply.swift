//
//  NoteDetailVC-DelReply.swift
//  SmallPink
//
//  Created by yalan on 2022/5/1.
//

import LeanCloud
extension NoteDetailVC{
    func delReply(_ reply: LCObject, _ indexPath: IndexPath){
        showDelAlert(for: "回复") { _ in
            //云端数据
            reply.delete { _ in }
            self.updateCommentCount(by: -1)
            
            //内存数据
            self.replies[indexPath.section].replies.remove(at: indexPath.row)
            
            //UI
            self.tableView.reloadData()
            
        }
        
    }
}
