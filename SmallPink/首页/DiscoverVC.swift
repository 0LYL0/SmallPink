//
//  DiscoverVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/8.
//

import UIKit
import XLPagerTabStrip
class DiscoverVC: UIViewController, IndicatorInfoProvider{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "发现")
    }

}
