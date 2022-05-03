//
//  CodeLoginVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/20.
//

import UIKit
import LeanCloud
import simd
private let totalTime = 3

class CodeLoginVC: UIViewController {
    
    private var timeRemain = totalTime
    
    lazy private var timer = Timer()
    
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var authCodeTF: UITextField!
    @IBOutlet weak var getAuthCodeBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var phoneNumStr: String {
        phoneNumTF.unwrappedText
    }
    private var authCodeStr: String{
        authCodeTF.unwrappedText
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        getAuthCodeBtn.isHidden = true
        loginBtn.setToDisabled()
        
        phoneNumTF.delegate = self
        authCodeTF.delegate = self
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func TFEditingChange(_ sender: UITextField) {
        if sender == phoneNumTF{
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum && getAuthCodeBtn.isEnabled
        }
        if phoneNumStr.isPhoneNum && authCodeStr.isAuthCode{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
       
    }
    
    
    @IBAction func getAuthCode(_ sender: Any) {
        getAuthCodeBtn.isEnabled = false
        getAuthCodeBtn.setTitle("重新发送(\(timeRemain)s)", for: .disabled)
        authCodeTF.becomeFirstResponder()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeAuthCodeBtnText), userInfo: nil, repeats: true)
        
        let variables: LCDictionary = [
            "ttl": LCNumber(5),         // 验证码有效时间为 10 分钟
            "name": LCString("小粉书"), // 应用名称
            //           "op": LCString("某种操作")    // 操作名称
        ]
        _ = LCSMSClient.requestShortMessage(
            mobilePhoneNumber: phoneNumStr,
            templateName: "",
            signatureName: "",
            variables: variables) { (result) in
                //           switch result {
                //           case .success:
                //               break
                //           case .failure(error: let error):
                //               print(error)
                //           }
                if case let .failure(error: error) = result{
                    print(error.reason ?? "短信验证码未知错误")
                }
            }
    }
    
    @IBAction func login(_ sender: UIButton) {
        view.endEditing(true)
        showLoadHUD()
        LCUser.signUpOrLogIn(mobilePhoneNumber: phoneNumStr, verificationCode: authCodeStr, completion: { result in
           
            switch result{
            case .success(object: let user):
                print(user)
                let randomNickName = "小粉书\(String.randomString(6))"
                self.configAfterLogin(user, randomNickName)
                
            case .failure(error: let error):
                self.hideLoadHUD()
                DispatchQueue.main.async {
                    self.showTextHUD("登录失败", true, error.reason)
                }
            }
        })
    }
    
}

extension CodeLoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limit = textField == phoneNumTF ? 11 : 6
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位哦")
        }
        return !isExceed
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumTF{
            authCodeTF.becomeFirstResponder()
        }else{
            if loginBtn.isEnabled{
                login(loginBtn)
            }
        }
        return true
    }
}

// MARK: -监听
extension CodeLoginVC{
    @objc private func changeAuthCodeBtnText(){
        timeRemain = timeRemain - 1
        getAuthCodeBtn.setTitle("重新发送(\(timeRemain)s)", for: .disabled)
        
        if timeRemain <= 0{
            timer.invalidate()
            timeRemain = totalTime
            getAuthCodeBtn.isEnabled = true
            getAuthCodeBtn.setTitle("发送验证码", for: .normal)
            
            getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum
        }
    }
    
    
}
