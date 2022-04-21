//
//  NoteEditVC-UI.swift
//  SmallPink
//
//  Created by yalan on 2022/4/15.
//

import Foundation
extension NoteEditVC{
    func setUI(){
        setDraftNoteEditUI()
    }
    private func setDraftNoteEditUI(){
        if let draftNote = draftNote{
            titleTextField.text = draftNote.title
            textView.text = draftNote.text
            channel = draftNote.channel!
            subChannel = draftNote.subChannel!
            poiName = draftNote.poiName!
            
            if !subChannel.isEmpty{
                updateChannelUI()
            }
            if !poiName.isEmpty{
                updatePOINameUI()
            }
        }
    }
    
    func updateChannelUI(){
        channelLabel.text = subChannel
        channelIcon.tintColor = blueColor
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
    func updatePOINameUI(){
        if poiName == ""{
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            poiNameLabel.text = self.poiName
            poiNameLabel.textColor = blueColor
            poiNameIcon.tintColor = blueColor
        }
    }
}
