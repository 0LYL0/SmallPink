//
//  WaterfallVC-DataSource.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension WaterfallVC{
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyDraft{
            return notes.count + 1
        }else if isDraft{
            return draftNotes.count
        }else{
            return notes.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isMyDraft, indexPath.item == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kMyDraftNoteWaterfallCellID, for: indexPath)
            return cell
        }else if isDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteDraftNote), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
//            cell.imageView.image = UIImage(named: "\(indexPath.row + 1)")
            cell.isMyselfLike = isMyselfLike
            let offset = isMyDraft ? 1 : 0
            cell.note = notes[indexPath.item - offset]
            return cell
        }
    }
   
    //删除草稿
    @objc func deleteDraftNote(_ sender: UIButton){
//        print(sender.tag)
        let index = sender.tag
        
        let alert = UIAlertController(title: "提示", message: "确认删除该草稿吗?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .destructive) { _ in
            backgroundContext.perform {
                //数据
                let draftNote = self.draftNotes[index]
                
                backgroundContext.delete(draftNote)
                appDelegate.savaBackgroundContext()
                
                self.draftNotes.remove(at: sender.tag)
                
                UserDefaults.decrease(kDraftNoteCount)
                //UI
                DispatchQueue.main.async {
                   
//                    self.collectionView.performBatchUpdates {
//                        self.collectionView.deleteItems(at: [IndexPath(item: sender.tag, section: 0)])
//                    }
                    self.collectionView.reloadData()
                    self.showTextHUD("删除草稿成功")
                }
            }
           
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
}
