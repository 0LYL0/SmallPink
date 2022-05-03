//
//  MeVC-HeaderView.swift
//  SmallPink
//
//  Created by yalan on 2022/5/3.
//

import LeanCloud
extension MeVC{
    func setHeaderView() -> UIView{
        let headerView = Bundle.loadView(fromNib: "MeHeaderView", with: MeHeaderView.self)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.heightAnchor.constraint(equalToConstant: headerView.rootStackView.frame.height + 26).isActive = true
        headerView.user = user
        if isFromNote{
            headerView.backOrSlideBtn.setImage(largeIcon("chevron.left"), for: .normal)
        }
        headerView.backOrSlideBtn.addTarget(self, action: #selector(backOrDrawer), for: .touchUpInside)
        if isMySelf{
            headerView.introLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(editIntro)))
        }else{
            if user.getExactStringVal(kIntroCol).isEmpty{
                headerView.introLabel.isHidden = true
            }
            if let _ = LCApplication.default.currentUser{
                headerView.editOrFollowBtn.setTitle("关注", for: .normal)
                headerView.editOrFollowBtn.backgroundColor = mainColor
            }else{
                headerView.editOrFollowBtn.setTitle("关注", for: .normal)
                headerView.editOrFollowBtn.backgroundColor = mainColor
            }
            headerView.settingOrChatBtn.setImage(fontIcon("ellipsis.bubble", fontSize: 13), for: .normal)
            
        }
        headerView.editOrFollowBtn.addTarget(self, action: #selector(editOrFollow), for: .touchUpInside)
        headerView.settingOrChatBtn.addTarget(self, action: #selector(settingOrChat), for: .touchUpInside)
        
        return headerView
    }
}
