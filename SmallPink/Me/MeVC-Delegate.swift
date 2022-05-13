//
//  MeVC-Delegate.swift
//  SmallPink
//
//  Created by yalan on 2022/5/10.
//

import Foundation
import LeanCloud
extension MeVC: EditProfileTableVCDelegate{
    func updateUser(_ avatar: UIImage?, _ nickName: String, _ gender: Bool, _ birth: Date?, _ intro: String) {
        if let avatar = avatar, let data = avatar.jpeg(.medium){
            let avatarFile = LCFile(payload: .data(data: data))
            avatarFile.save(to: user, as: kAvatarCol)
            meHeaderView.avatarImageView.image = avatar
        }
        
        try? user.set(kNickNameCol, value: nickName)
        meHeaderView.nickNameLabel.text = nickName
        
        try? user.set(kGenderCol, value: gender)
        meHeaderView.genderLabel.text = gender ? "♂" : "♀"
        meHeaderView.genderLabel.textColor = gender ? blueColor : mainColor
        
        try? user.set(kBirthCol, value: birth)
        
        try? user.set(kIntroCol, value: intro)
        meHeaderView.introLabel.text = intro.isEmpty ? kIntroPH : intro
        
        user.save{ _ in }
    }
}
