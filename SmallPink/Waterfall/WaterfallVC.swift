//
//  WaterfallVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import UIKit
import CHTCollectionViewWaterfallLayout
import XLPagerTabStrip
import LeanCloud
import SegementSlide
import MJRefresh

class WaterfallVC: UICollectionViewController, CHTCollectionViewDelegateWaterfallLayout, SegementSlideContentScrollViewDelegate {
    
    lazy var header = MJRefreshNormalHeader()
    
    @objc var scrollView: UIScrollView {
        return collectionView
    }
   
    var channel = ""
    //草稿相关数据
    var isDraft = false
    var draftNotes : [DraftNote] = []
    
    //首页相关数据
    var notes: [LCObject] = []
    
    //个人页面相关数据
    var isMyDraft = false
    var user: LCUser?
    var isMyNote = false
    var isMyFav = false
    var isMyselfLike = false
    
    var isFromMeVC = false
    var fromMeVCUser: LCUser?

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        if let _ = user {//个人页面
            if isMyNote{
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyNotes))
                
            }else if isMyFav{
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyFavNotes))
            }else{
                header.setRefreshingTarget(self, refreshingAction: #selector(getMyLikeNotes))
            }
            header.beginRefreshing()
        }else if isDraft{//草稿总页面
            loadDriftNotes()
        }else{//首页
            header.setRefreshingTarget(self, refreshingAction: #selector(getNotes))
            header.beginRefreshing()
        }
        
        
        
//        print(NSHomeDirectory())
//        FileManager.default.save(UIImage(named: "1")?.pngData(), to: "testDir", as: "test")
//        
    }
    
    @IBAction func dismissDraftNotesVC(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension WaterfallVC: IndicatorInfoProvider{
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: channel)
    }
}
