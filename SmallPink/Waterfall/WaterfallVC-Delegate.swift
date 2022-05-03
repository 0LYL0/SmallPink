//
//  WaterfallVC-Delegate.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension WaterfallVC{
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isMyDraft, indexPath.item == 0{
            let navi = storyboard!.instantiateViewController(withIdentifier: kDraftNotesNavID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen
            ((navi.topViewController) as! WaterfallVC).isDraft = true
            present(navi, animated: true)
        }else if isDraft{
            let draftNote = draftNotes[indexPath.item]
            if let phptosData = draftNote.photos,
               let photosDataArr = try? JSONDecoder().decode([Data].self, from: phptosData){
                
                let photos = photosDataArr.map { data  -> UIImage in
                    UIImage(data) ?? imagePH
                }
                let videoURL = FileManager.default.save(draftNote.video, to: "video", as: "\(UUID().uuidString).mp4")
                let vc = storyboard?.instantiateViewController(withIdentifier: kNoteEditVCID) as! NoteEditVC
                vc.draftNote = draftNote
                vc.photos = photos
                vc.videoURL = videoURL
                vc.updateDraftNoteFinished = {
                    self.loadDriftNotes()
                    self.collectionView.reloadData()
                }
                vc.postDraftNoteFinished = {
                    self.loadDriftNotes()
                }
                navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showLoadHUD("加载草稿失败")
            }
        }else{
            let offset = isMyDraft ? 1 : 0
            let item = indexPath.item - offset
            //依赖注入
            let detailVC = storyboard!.instantiateViewController(identifier: kNoteDetailVCID){ coder in
                NoteDetailVC(coder: coder, note: self.notes[item])
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? WaterfallCell{
                detailVC.isLikeFromWaterfallCell = cell.isLike
            }
            detailVC.delNoteFinished = {
                self.notes.remove(at: item)
                collectionView.performBatchUpdates {
                    collectionView.deleteItems(at: [indexPath])
                }
            }
            
            detailVC.isFromMeVC = isFromMeVC
            detailVC.fromMeVCUser = fromMeVCUser
            
            detailVC.modalPresentationStyle = .fullScreen
            present(detailVC, animated: true, completion: nil)
        }
    }
}
