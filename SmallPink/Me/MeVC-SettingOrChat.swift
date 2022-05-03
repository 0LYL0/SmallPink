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
            
        }else{
            if let _ = LCApplication.default.currentUser{
                print("私信功能")
            }else{
                showLoginHUD()
            }
        }
    }
}
