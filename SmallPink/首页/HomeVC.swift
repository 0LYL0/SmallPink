//
//  HomeVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/8.
//

import UIKit
import XLPagerTabStrip

class HomeVC: ButtonBarPagerTabStripViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let followVC = storyboard!.instantiateViewController(withIdentifier: kFollowVCID)
        let discoverVC = storyboard!.instantiateViewController(withIdentifier: kDiscoverVCID)
        let nearbyVC = storyboard!.instantiateViewController(withIdentifier: kNearbyVCID)
        return [followVC, nearbyVC, discoverVC]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
