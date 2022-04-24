//
//  NearbyVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/8.
//

import UIKit
import XLPagerTabStrip

class NearbyVC: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: - DispatchGroup
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.global().asyncAfter(deadline: .now() + 3){
            print("1")
            
            group.enter()
            DispatchQueue.global().asyncAfter(deadline: .now() + 3){
                print("2")
                group.leave()
            }
            
            group.leave()
        }
        group.notify(queue: .main){
            print("3")
        }
    }
    
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "附近")
    }

}
