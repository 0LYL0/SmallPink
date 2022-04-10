//
//  Extensions.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import Foundation

extension Bundle{
    var appName: String{
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            return appName
        }else{
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
}
