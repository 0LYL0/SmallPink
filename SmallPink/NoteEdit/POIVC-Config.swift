//
//  POIVC-Config.swift
//  SmallPink
//
//  Created by yalan on 2022/4/13.
//

import Foundation
extension POIVC{
    func congig(){
        
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.locationTimeout = 5
        locationManager.reGeocodeTimeout = 2
        
        tableView.mj_footer = footer
        
        //searchbar一开始点取消不生效的bug
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton{
            cancelButton.isEnabled = true
        }
    }
}

