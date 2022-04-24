//
//  LoginVC-LocalLogin.swift
//  SmallPink
//
//  Created by yalan on 2022/4/18.
//

import Foundation
import UIKit
import Alamofire
extension UIViewController{
    @objc func localLogin(){
        showLoadHUD()
        let config = JVAuthConfig()
        config.appKey = kJAppKey
        config.authBlock = { _ in
            if JVERIFICATIONService.isSetupClient(){
                JVERIFICATIONService.preLogin(5000) { (result) in
                    self.hideLoadHUD()
                    if let result = result, let code = result["code"] as? Int, code == 7000 {
                        //预取号成功
                        self.setLocalLoginUI()
                        self.presentLocalLoginVC()
                         
                    }else{
                        
//                        print("预取号失败,错误码:\(result!["code"]),错误描述:\(result!["content"])")
                    }
                }
            }else{
                self.hideLoadHUD()
                self.presentCodeLoginVC()
            }
        }
        JVERIFICATIONService.setup(with: config)
    }
    
    @objc private func otherLogin(){
        JVERIFICATIONService.dismissLoginController(animated: true) {
            self.presentCodeLoginVC()
        }
       
    }
    @objc private func dismissLocalLoginVC(){
        JVERIFICATIONService.dismissLoginController(animated: true, completion: nil)
    }
    // MARK: 一般函数
    private func presentCodeLoginVC(){
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let loginNaviC = mainSB.instantiateViewController(withIdentifier: kLoginNavID)
        loginNaviC.modalPresentationStyle = .fullScreen
        self.present(loginNaviC, animated: true, completion: nil)
    }
    
    // MARK: 弹出一键登录页+用户点击登录后
    private func presentLocalLoginVC(){
        JVERIFICATIONService.getAuthorizationWith(self, hide: true, animated: true, timeout: 5*1000, completion: { (result) in
            if let result = result, let loginToken = result["loginToken"] as? String{
                //一键登录成功
                print("loginToken: \(loginToken)")
                JVERIFICATIONService.clearPreLoginCache()
//                self.getEncryptedPhoneNum(loginToken)
              
            }else{
                print("一键登录失败")
                self.otherLogin()
            }
        }) { (type, content) in
            if let content = content {
                print("一键登录 actionBlock :type = \(type), content = \(content)")
            }
        }
    }
    
    private func setLocalLoginUI(){
        let config = JVUIConfig()
        //状态栏
        config.prefersStatusBarHidden = true
        //导航栏
        config.navTransparent = true
        config.navText = NSAttributedString(string: "  ")
        config.navReturnHidden = true
        config.navControl = UIBarButtonItem(title: "关闭", style: .plain, target: self, action: #selector(dismissLocalLoginVC))
        
        let constrainX = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: .centerX, multiplier: 1, constant: 0)!
        
        let loginConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1/7, constant: 0)
        config.logoConstraints = [constrainX,loginConstraintY!]
        
        let numberConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 35)
        config.numberConstraints = [constrainX,numberConstraintY!]
        
        let sloganContrainY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.number, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 35)
        config.sloganConstraints = [constrainX,sloganContrainY!]
        
        config.logBtnText = "同意协议并一键登录"
        config.logBtnImgs = [
            UIImage(named: "localLoginBtn-nor")!,
            UIImage(named: "localLoginBtn-nor")!,
            UIImage(named: "localLoginBtn-hig")!
        ]
        let logBtnConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.slogan, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: 50)
        config.logBtnConstraints = [constrainX,logBtnConstraintY!]
        
        config.privacyState = true
        config.checkViewHidden = true
        
        config.appPrivacyOne = ["用户协议","https://www.cnblogs.com/"]
        config.appPrivacyTwo = ["隐私政策","https://www.cnblogs.com/"]
        config.privacyComponents = ["登录注册代表你已同意","以及","和","  "]
        config.appPrivacyColor = [UIColor.secondaryLabel,blueColor]
        config.privacyTextAlignment = .center
        let privacyConstraintY = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.super, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -50)
        let privacyConstraintW = JVLayoutConstraint(attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, to: JVLayoutItem.none, attribute: NSLayoutConstraint.Attribute.width, multiplier: 1, constant: 255)!
        config.privacyConstraints = [constrainX,privacyConstraintY!,privacyConstraintW]
        
        config.agreementNavBackgroundColor = mainColor
        config.agreementNavReturnImage = UIImage(systemName: "chevron.left")
        
        JVERIFICATIONService.customUI(with: config){ [self] customView in
            guard let customView = customView else { return }
            let otherLoginBtn = UIButton()
            otherLoginBtn.setTitle("其他方式登录", for: .normal)
            otherLoginBtn.setTitleColor(.secondaryLabel, for: .normal)
            otherLoginBtn.titleLabel?.font = .systemFont(ofSize: 15)
            otherLoginBtn.translatesAutoresizingMaskIntoConstraints = false
            otherLoginBtn.addTarget(self, action: #selector(self.otherLogin), for: .touchUpInside)
            
            customView.addSubview(otherLoginBtn)
            
            NSLayoutConstraint.activate([
                otherLoginBtn.centerXAnchor.constraint(equalTo: customView.centerXAnchor),
                otherLoginBtn.centerYAnchor.constraint(equalTo: customView.centerYAnchor, constant: 170),
                otherLoginBtn.widthAnchor.constraint(equalToConstant: 279)
            ])
        }
    }
}

extension UIViewController{
    
    struct LocalLoginRes: Decodable{
        let phone: String
    }
    
    private func getEncryptedPhoneNum(_ loginToken: String){
        let headers: HTTPHeaders = [
            .authorization(username: kJAppKey, password: "")
        ]
        
        let parameters = ["loginToken": loginToken]
        
        AF.request("https://api.verification.jpush.cn/v1/web/loginTokenVerify",
                   method: .post,
                   parameters: parameters,
                   encoder: JSONParameterEncoder.default,
                   headers: headers
        ).responseDecodable(of: LocalLoginRes.self) { response in
            if let localLoginRes = response.value{
                print(localLoginRes.phone)
            }
            
        }
        
    }
}
