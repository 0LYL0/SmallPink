//
//  SettingTableVC-Delegate.swift
//  SmallPink
//
//  Created by yalan on 2022/5/10.
//

import Foundation
import Kingfisher
import UIKit
import LeanCloud
extension SettingTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let section = indexPath.section
        let row = indexPath.row
        if section == 1, row == 1{
            ImageCache.default.clearCache {
                self.showTextHUD("清除缓存成功")
                self.cacheSizeLabel.text = kNoCachePH
            }
        }else if section == 3{
            let appID = "当前App的ID"
            let path = "https://itunes.apple.com/app/id/\(appID)?action=write-review"
            
            guard let url = URL(string: path), UIApplication.shared.canOpenURL(url) else { return }
            UIApplication.shared.open(url)
        }else if section == 4{
            dismiss(animated: true)
            LCUser.logOut()
            let loginVC = storyboard!.instantiateViewController(withIdentifier: kLoginVCID)
            loginAndMeParentVC.removeChildren()
            loginAndMeParentVC.add(child: loginVC)
        }
    }
}
