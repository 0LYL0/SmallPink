//
//  WaterfallVC-Layout.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
extension WaterfallVC{
    // MARK: -CollectionViewLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellW = (screenRect.width - kWaterfallPadding * 3) / 2
        var cellH: CGFloat = 0
        if isMyDraft, indexPath.item == 0{
            cellH = 100
        }else if isDraft{
            let draftNote = draftNotes[indexPath.item]
            let image = UIImage(draftNote.coverPhoto) ?? imagePH
            let imageH = image.size.height
            let imageW = image.size.width
            let imageRatio = imageH / imageW
            cellH = cellW * imageRatio + kDraftNoteWaterfallCellBottomViewH
        }else{
//            cellH = UIImage(named: "\(indexPath.row + 1)")!.size.height
            let offset = isMyDraft ? 1 : 0
            let note = notes[indexPath.item - offset]
            let coverPhotoRatio = CGFloat(note.getExactDoubleVal(kCoverPhotoRatioCol))
            cellH = cellW * coverPhotoRatio + kWaterfallCellBottomViewH
        }
        
        return CGSize(width: cellW, height: cellH)
    }
}
