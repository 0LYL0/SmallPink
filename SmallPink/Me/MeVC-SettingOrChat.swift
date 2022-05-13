//
//  MeVC-SettingOrChat.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import LeanCloud
extension MeVC{
    @objc func settingOrChat(){
        if isMySelf{//设置
            let settingTableVC = storyboard!.instantiateViewController(withIdentifier: kSettingTableVCID) as! SettingTableVC
            settingTableVC.user = user
            present(settingTableVC,animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                showTextHUD("私信功能")
            }else{
                showLoginHUD()
            }
        }
    }
}
