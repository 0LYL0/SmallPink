//
//  MeVC-Config.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import LeanCloud
extension MeVC{
    func config(){
        //        navigationItem.backButtonTitle = ""
        navigationItem.backButtonDisplayMode = .minimal
        //        navigationController?.navigationBar.tintColor = .label
        
        if let user = LCApplication.default.currentUser, user == self.user{
            isMySelf = true
        }
    }
}
