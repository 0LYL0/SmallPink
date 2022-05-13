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
            let navi = storyboard?.instantiateViewController(identifier: kEditProfileNavID) as! UINavigationController
            navi.modalPresentationStyle = .fullScreen
            let editProfileTableVC = navi.topViewController as! EditProfileTableVC
            editProfileTableVC.user = user
            editProfileTableVC.delegate = self
            present(navi, animated: true)
        }else{
            if let _ = LCApplication.default.currentUser{
                showTextHUD("关注和取消关注功能")
            }else{
                showLoginHUD()
            }
        }
    }
}
