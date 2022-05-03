//
//  Login-Extensions.swift
//  SmallPink
//
//  Created by yalan on 2022/4/23.
//

import LeanCloud
extension UIViewController{
    func configAfterLogin(_ user: LCUser, _ nickName: String, _ email: String = ""){
        if let _ = user.get(kNickNameCol){
            dismissAndShowMeVc(user)
        }else{//首次登录(注册)
            let group = DispatchGroup()
            
            let randomAvatar = UIImage(named: "avatarPH\(Int.random(in: 1...4))")!
            if let avatarData = randomAvatar.pngData(){
                let avatarFile = LCFile(payload: .data(data: avatarData))
                avatarFile.mimeType = "image/jpeg"
                
                avatarFile.save(to: user, as: kAvatarCol, group: group)
            }
            do{
                if email != ""{
                    user.email = LCString(email)
                }
                try user.set(kNickNameCol, value: nickName)
            }catch{
                print("给字段赋值失败\(error)")
                return
            }
            group.enter()
            user.save { result in
                group.leave()
            }
            
            group.enter()
            let userInfo = LCObject(className: kUserInfoTable)
            try? userInfo.set(kUserObjectIdCol, value: user.objectId)
            userInfo.save{ _ in group.leave() }
            
            group.notify(queue: .main){
                self.dismissAndShowMeVc(user)
//                print(user.get(kNickNameCol)?.stringValue)
//                print((user.get(kAvatarCol) as! LCFile).name?.stringValue)
            }
            
        }
      
    }
    
    func dismissAndShowMeVc(_ user: LCUser){
        hideLoadHUD()
        DispatchQueue.main.async {
            let mainSB = UIStoryboard(name: "Main", bundle: nil)
            let meVC = mainSB.instantiateViewController(identifier: kMeVCID) { coder in
                MeVC(coder: coder, user: user)
            }
            loginAndMeParentVC.removeChildren()
            loginAndMeParentVC.add(child: meVC)
            
            self.dismiss(animated: true)
        }
    }
}
