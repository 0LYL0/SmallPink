//
//  MeVC-EditOrFollow.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import LeanCloud
extension MeVC{
    @objc func editOrFollow(){
        if isMySelf{//编辑资料
            
        }else{
            if let _ = LCApplication.default.currentUser{
                print("关注和取消关注功能")
            }else{
                showLoginHUD()
            }
        }
    }
}
