//
//  NoteDetailVC-DelNote.swift
//  SmallPink
//
//  Created by yalan on 2022/4/27.
//

import Foundation
import LeanCloud

extension NoteDetailVC{
    func delNote(){
        showDelAlert(for: "笔记") { _ in
            //数据
            self.delLCNote()
            //UI
            self.dismiss(animated: true) {
                self.delNoteFinished?()
            }
        }
    }
    private func delLCNote(){
        
        note.delete { res in
            if case .success = res{
                DispatchQueue.main.async {
                    self.showTextHUD("笔记已删除")
                }
            }
        }
        
    }
}
