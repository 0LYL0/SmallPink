//
//  MeVC-HeaderView.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import LeanCloud
extension MeVC{
    func setHeaderView() -> UIView{
        
        meHeaderView.translatesAutoresizingMaskIntoConstraints = false
        meHeaderView.heightAnchor.constraint(equalToConstant: meHeaderView.rootStackView.frame.height + 26).isActive = true
        meHeaderView.user = user
        if isFromNote{
            meHeaderView.backOrSlideBtn.setImage(largeIcon("chevron.left"), for: .normal)
        }
        meHeaderView.backOrSlideBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)
        if isMySelf{
            meHeaderView.introLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))
        }else{
            if user.getExactStringVal(kIntroCol).isEmpty{
                meHeaderView.introLabel.isHidden = true
            }
            if let _ = LCApplication.default.currentUser{
                meHeaderView.editOrFollowBtn.setTitle("关注", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }else{
                meHeaderView.editOrFollowBtn.setTitle("关注", for: .normal)
                meHeaderView.editOrFollowBtn.backgroundColor = mainColor
            }
            meHeaderView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
            
        }
        meHeaderView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)
        meHeaderView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)
        
        return meHeaderView
    }
}
