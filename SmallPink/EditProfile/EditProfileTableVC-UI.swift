//
//  EditProfileTableVC-UI.swift
//  SmallPink
//
//  Created by yalan on 2022/5/9.
//

import Kingfisher
extension EditProfileTableVC{
    func setUI(){
        avatarImageView.kf.setImage(with: user.getImageURL(from: kAvatarCol, .avator))
        nickName = user.getExactStringVal(kNickNameCol)
        gender = user.getExactBoolValDefaultF(kGenderCol)
        birth = user.get(kBirthCol)?.dateValue
        intro = user.getExactStringVal(kIntroCol)
    }
}
