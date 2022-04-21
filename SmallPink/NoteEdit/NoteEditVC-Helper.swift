//
//  NoteEditVC-Helper.swift
//  SmallPink
//
//  Created by yalan on 2022/4/15.
//

import Foundation
extension NoteEditVC{
    func isValidateNote() -> Bool{
        
        guard !photos.isEmpty else{
            showTextHUD("至少一张图片")
            return false
        }
        
        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else {
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
            return false
        }
        return true
    }
}
