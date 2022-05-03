//
//  WaterfallVC-Config.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import Foundation
import CHTCollectionViewWaterfallLayout
extension WaterfallVC{
    func config(){
        let layout = collectionView.collectionViewLayout as! CHTCollectionViewWaterfallLayout
        
        layout.columnCount = 2
        layout.minimumColumnSpacing = kWaterfallPadding
        layout.minimumInteritemSpacing = kWaterfallPadding
        var inset: UIEdgeInsets = .zero
        if let _ = user{
            inset = UIEdgeInsets(top: 10, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }else{
            inset = UIEdgeInsets(top: 0, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
        }
        layout.sectionInset = inset
        
//        if isDraft{
//            layout.sectionInset = UIEdgeInsets(top: 44, left: kWaterfallPadding, bottom: kWaterfallPadding, right: kWaterfallPadding)
//        }
        if isDraft{
            navigationItem.title = "本地草稿"
            navigationController?.navigationBar.isTranslucent = false;
            navigationController?.navigationBar.backgroundColor = .white
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            self.navigationController?.navigationBar.standardAppearance =  appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        collectionView.register(UINib(nibName: "MyDraftNoteWaterfallCell", bundle: nil), forCellWithReuseIdentifier: kMyDraftNoteWaterfallCellID)
        
        collectionView.mj_header = header
    }
}
