//
//  NoteEditVC-DraftNote.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension NoteEditVC{
    // MARK: 新创建的笔记
    func creatDraftNote(){
        backgroundContext.perform{
            let draftNote = DraftNote(context: backgroundContext)
            if self.isVideo{
                draftNote.video = try? Data(contentsOf: self.videoURL!)
            }
            draftNote.coverPhoto = self.photos[0].jpeg(.high)

            var photos: [Data] = []
            for photo in self.photos {
                if let pngData = photo.pngData(){
                    photos.append(pngData)
                }
            }
            draftNote.photos = try? JSONEncoder().encode(photos)
            
            draftNote.isVideo = self.isVideo
            DispatchQueue.main.async {
                draftNote.title = self.titleTextField.exactText
                draftNote.text = self.textView.exactText
            }
            draftNote.channel = self.channel
            draftNote.subChannel = self.subChannel
            draftNote.poiName = self.poiName
            draftNote.updateAt = Date()
            
            appDelegate.savaBackgroundContext()
            
            UserDefaults.increase(kDraftNoteCount)
            DispatchQueue.main.async {
                self.showTextHUD("保存草稿成功", false)
            }
        }
        dismiss(animated: true)
    }
    // MARK: 更新笔记
    func updateDraftNote(_ draftNote: DraftNote){
        backgroundContext.perform{
            if !self.isVideo{
                draftNote.coverPhoto = self.photos[0].jpeg(.high)
                var photos: [Data] = []
                for photo in self.photos{
                    if let pngData = photo.pngData(){
                        photos.append(pngData)
                    }
                }
                draftNote.photos = try? JSONEncoder().encode(photos)
            }
            
            DispatchQueue.main.async {
                draftNote.title = self.titleTextField.exactText
                draftNote.text = self.textView.exactText
            }
            draftNote.channel = self.channel
            draftNote.subChannel = self.subChannel
            draftNote.poiName = self.poiName
            draftNote.updateAt = Date()
            
            appDelegate.savaBackgroundContext()
            
            DispatchQueue.main.async {
                self.updateDraftNoteFinished?()
//                self.showTextHUD("保存草稿成功")
            }
            
        }
        navigationController?.popViewController(animated: true)
    }
}
