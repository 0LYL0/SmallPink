//
//  MeVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/15.
//

import UIKit
import LeanCloud
import SegementSlide

class MeVC: SegementSlideDefaultViewController {
    
    var user: LCUser
    lazy var meHeaderView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)
    
    var isFromNote = false
    var isMySelf = false
    
    init?(coder: NSCoder, user: LCUser){
        self.user = user
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        config()
        setUI()
      
        // Do any additional setup after loading the view.
    }
    override var bouncesType: BouncesType{
        .child
    }
    //头部视图
    override func segementSlideHeaderView() -> UIView? {
        setHeaderView()
    }
    //tab标题
    override var titlesInSwitcher: [String] {
        return ["笔记", "收藏", "赞过"]
    }
    //tab
    override var switcherConfig: SegementSlideDefaultSwitcherConfig{
        var config = super.switcherConfig
        config.type = .tab
        config.selectedTitleColor = .label
        config.indicatorColor = mainColor
        
        return config
    }
    //内层滚动视图
    override func segementSlideContentViewController(at index: Int) -> SegementSlideContentScrollViewDelegate? {
        let isMyDraft = (index == 0) && isMySelf && (UserDefaults.standard.integer(forKey: kDraftNoteCount) > 0)
        let vc = storyboard?.instantiateViewController(withIdentifier: kWaterfallVCID) as! WaterfallVC
        vc.isMyDraft = isMyDraft
        vc.user = user
        vc.isMyNote = index == 0
        vc.isMyFav = index == 1
        vc.isMyselfLike = (isMySelf && index == 2)
        vc.isFromMeVC = true
        vc.fromMeVCUser = user
        return vc
    }
    
    //    @IBAction func logoutTest(_ sender: Any) {
    //        LCUser.logOut()
    //        let loginVC = storyboard!.instantiateViewController(withIdentifier: kLoginVCID)
    //        loginAndMeParentVC.removeChildren()
    //        loginAndMeParentVC.add(child: loginVC)
    //    }
    //
    //    @IBAction func showDraftNotes(_ sender: Any) {
    //        let navi = storyboard!.instantiateViewController(withIdentifier: kDraftNotesNavID)
    //        navi.modalPresentationStyle = .fullScreen
    //        present(navi, animated: true)
    //    }
    //
}
