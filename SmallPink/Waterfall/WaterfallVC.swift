//
//  WaterfallVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip


class WaterfallVC: UICollectionViewController, CHTCollectionViewDelegateWaterfallLayout {
   
    var channel = ""
    var isMyDraft = true
    var draftNotes : [DraftNote] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        layout.sectionInset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        
        if isMyDraft{
            layout.sectionInset = UIEdgeInsets(top: 44, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }
        
        loadDriftNotes()
        
//        print(NSHomeDirectory())
//        FileManager.default.save(UIImage(named: "1")?.pngData(), to: "testDir", as: "test")
//        
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isMyDraft{
            return draftNotes.count
        }
        return 13
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isMyDraft{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kDraftNoteWaterfallCellID, for: indexPath) as! DraftNoteWaterfallCell
            cell.draftNote = draftNotes[indexPath.item]
            cell.deleteBtn.tag = indexPath.item
            cell.deleteBtn.addTarget(self, action: #selector(deleteDraftNote), for: .touchUpInside)
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWaterfallCellID, for: indexPath) as! WaterfallCell
            cell.imageView.image = UIImage(named: "\(indexPath.row + 1)")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        var cellH: CGFloat = 0
        if isMyDraft{
            let draftNote = draftNotes[indexPath.item]
            let image = UIImage(draftNote.coverPhoto) ?? imagePH
            let imageH = image.size.height
            let imageW = image.size.width
            let imageRatio = imageH / imageW
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
            cellH = UIImage(named: "\(indexPath.row + 1)")!.size.height
        }
        
        return CGSize(width: cellW, height: cellH)
    }
    
    @objc func deleteDraftNote(_ sender: UIButton){
        print(sender.tag)
        let index = sender.tag
        
        let alert = UIAlertController(title: "提示", message: "确认删除该草稿吗?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "取消", style: .cancel)
        let action2 = UIAlertAction(title: "确认", style: .destructive) { _ in
            //数据
            let draftNote = self.draftNotes[index]
            context.delete(draftNote)
            appDelegate.saveContext()
            self.draftNotes.remove(at: sender.tag)
            //UI
            self.collectionView.performBatchUpdates {
                self.collectionView.deleteItems(at: [IndexPath(item: sender.tag, section: 0)])
            }
        }
        alert.addAction(action1)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isMyDraft{
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
                navigationController?.pushViewController(vc, animated: true)
                
            }else{
                showLoadHUD("加载草稿失败")
            }
        }else{
            
        }
    }
}
extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
