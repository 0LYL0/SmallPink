//
//  NoteDetailVC-EditNote.swift
//  SmallPink
//
//  Created by yalan on 2022/4/27.
//

import Foundation
import LeanCloud
import Kingfisher
extension NoteDetailVC{
    func editNote(){
        //从缓存(内存)中获取当前笔记的图片
        var photos: [UIImage] = []
        if let coverPhotoPath = (note.get(kCoverPhotoCol) as? LCFile)?.url?.stringValue,
           let coverPhoto = ImageCache.default.retrieveImageInMemoryCache(forKey: coverPhotoPath){
            photos.append(coverPhoto)
        }
        if let photoPaths = note.get(kPhotosCol)?.arrayValue as? [String]{
            let otherPhotos = photoPaths.compactMap{ ImageCache.default.retrieveImageInMemoryCache(forKey: $0)
            }
            photos.append(contentsOf: otherPhotos)
        }
        
        //视频处理(略过)
        //----------------------------------
        
        let vc = storyboard!.instantiateViewController(withIdentifier: kNoteEditVCID) as! NoteEditVC
        vc.note = note
        vc.photos = photos
        vc.videoURL = nil
        vc.updateNoteFinished = { noteID in
            let query = LCQuery(className: kNoteTable)
           
            query.get(noteID){ res in
               
                if case let .success(object: note) = res{
                    self.note = note
                    
                    self.showNote(true)
                }
            }
        }
//        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
