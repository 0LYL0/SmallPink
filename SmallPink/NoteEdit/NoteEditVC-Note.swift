//
//  NoteEditVC-Note.swift
//  SmallPink
//
//  Created by yalan on 2022/4/24.
//

import LeanCloud
extension NoteEditVC{
    func createNote(){
        do {
            let noteGroup = DispatchGroup()
            
            let note = LCObject(className: kNoteTable)
            
            if let videoURL = self.videoURL {
                let video = LCFile(payload: .fileURL(fileURL: videoURL))
                video.save(to: note, as: kVideoCol, group: noteGroup)
            }
            if let coverPhotoData = photos[0].jpeg(.high){
                let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
//                coverPhoto.mimeType = "image/jpeg"
                coverPhoto.save(to: note, as: kCoverPhotoCol, group: noteGroup)
            }
            
            let photoGroup = DispatchGroup()
            //1.把所有文件存进云端
            var photoPaths: [Int: String] = [:]
            for (index, eachPhoto) in photos.enumerated() {
                if let eachPhotoData = eachPhoto.jpeg(.high){
                    let photo = LCFile(payload: .data(data: eachPhotoData))
                    photoGroup.enter()
                    photo.save { res in
//                        print("photo文件保存成功/失败")
                        if case .success = res, let path = photo.url?.stringValue{
                            photoPaths[index] = path
                        }
                        photoGroup.leave()
                    }
                }
            }
            //2.得到所有的url进行排序
            noteGroup.enter()
            photoGroup.notify(queue: .main){
                let photoPathsArr = photoPaths.sorted(by: <).map{ $0.value }
                do{
                    try note.set(kPhotosCol, value: photoPathsArr)
                    note.save { res in
//                        print("存储photos成功/失败")
                        noteGroup.leave()
                    }
                }catch{
                    print("字段赋值失败")
                }
            }
            
            // MARK: 一般类型的存储
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            try note.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try note.set(kTitleCol, value: titleTextField.exactText)
            try note.set(kTextCol, value: textView.exactText)
            try note.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try note.set(kSubChannelCol, value: subChannel)
            try note.set(kPOINameCol, value: poiName)
            try note.set(kLikeCountCol, value: 0)
            try note.set(kFavCountCol, value: 0)
            try note.set(kCommentCountCol, value: 0)
            //笔记的作者
            try note.set(kAuthorCol, value: LCApplication.default.currentUser!)
            
            noteGroup.enter()
            note.save { res in
//                print("存储一般数据成功/失败")
                noteGroup.leave()
            }
            
            noteGroup.notify(queue: .main){
//                print("笔记全部存储结束")
                self.showTextHUD("发布笔记成功", false)
            }
            if draftNote != nil{
                navigationController?.popViewController(animated: true)
            }else{
                dismiss(animated: true)
            }
        } catch {
            print("存笔记进云端失败:\(error)")
        }
    }
    
    func postDraftNote(_ draftNote: DraftNote){
        createNote()
        backgroundContext.perform {
            //数据
           
            backgroundContext.delete(draftNote)
            appDelegate.savaBackgroundContext()
            
            //UI
            DispatchQueue.main.async {
                self.postDraftNoteFinished?()
            }
        }
    }
    
    func updateNote(_ note: LCObject){
        do {
            let noteGroup = DispatchGroup()
            
            if !isVideo{
                if let coverPhotoData = photos[0].jpeg(.high){
                    let coverPhoto = LCFile(payload: .data(data: coverPhotoData))
    //                coverPhoto.mimeType = "image/jpeg"
                    coverPhoto.save(to: note, as: kCoverPhotoCol, group: noteGroup)
                }
                
                let photoGroup = DispatchGroup()
                //1.把所有文件存进云端
                var photoPaths: [Int: String] = [:]
                for (index, eachPhoto) in photos.enumerated() {
                    if let eachPhotoData = eachPhoto.jpeg(.high){
                        let photo = LCFile(payload: .data(data: eachPhotoData))
                        photoGroup.enter()
                        photo.save { res in
    //                        print("photo文件保存成功/失败")
                            if case .success = res, let path = photo.url?.stringValue{
                                photoPaths[index] = path
                            }
                            photoGroup.leave()
                        }
                    }
                }
                //2.得到所有的url进行排序
                noteGroup.enter()
                photoGroup.notify(queue: .main){
                    let photoPathsArr = photoPaths.sorted(by: <).map{ $0.value }
                    do{
                        try note.set(kPhotosCol, value: photoPathsArr)
                        note.save { res in
    //                        print("存储photos成功/失败")
                            noteGroup.leave()
                        }
                    }catch{
                        print("字段赋值失败")
                    }
                }
            }
         
//            if let videoURL = self.videoURL {
//                let video = LCFile(payload: .fileURL(fileURL: videoURL))
//                video.save(to: note, as: kVideoCol, group: noteGroup)
//            }
           
            
            // MARK: 一般类型的存储
            let coverPhotoSize = photos[0].size
            let coverPhotoRatio = Double(coverPhotoSize.height / coverPhotoSize.width)
            try note.set(kCoverPhotoRatioCol, value: coverPhotoRatio)
            try note.set(kTitleCol, value: titleTextField.exactText)
            try note.set(kTextCol, value: textView.exactText)
            try note.set(kChannelCol, value: channel.isEmpty ? "推荐" : channel)
            try note.set(kSubChannelCol, value: subChannel)
            try note.set(kPOINameCol, value: poiName)
            
            try note.set(kHasEditCol, value: true)
            
            noteGroup.enter()
            note.save { res in
//                print("存储一般数据成功/失败")
                noteGroup.leave()
            }
            
            noteGroup.notify(queue: .main){
//                print("笔记全部存储结束")
                self.updateNoteFinished?(note.objectId!.stringValue!)
                self.showTextHUD("更新笔记成功", false)
            }
            dismiss(animated: true)
            
        } catch {
            print("存笔记进云端失败:\(error)")
        }
    }
}
