//
//  PasswordLoginVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/20.
//

import UIKit
import LeanCloud

class PasswordLoginVC: UIViewController {

    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    private var phoneNumStr: String{ phoneNumTF.unwrappedText }
    private var passwordStr: String{ passwordTF.unwrappedText }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        phoneNumTF.delegate = self
        passwordTF.delegate = self
        
        hideKeyboardWhenTappedAround()
        loginBtn.setToDisabled()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func backToCodeLoginVC(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func TFEditChange(_ sender: Any) {
        if phoneNumStr.isPhoneNum && passwordStr.isPassword{
            loginBtn.setToEnabled()
        }else{
            loginBtn.setToDisabled()
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        view.endEditing(true)
        showLoadHUD()
        LCUser.logIn(mobilePhoneNumber: phoneNumStr, password: passwordStr) { result in
            switch result {
            case .success(object: let user):
                self.dismissAndShowMeVc(user)
            case .failure(error: let error):
                self.hideLoadHUD()
                DispatchQueue.main.async {
                    self.showTextHUD("登录失败", true, error.reason)
                }
            }
        }
    }
    
}
extension PasswordLoginVC: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limit = textField == phoneNumTF ? 11 : 16
        let isExceed = range.location >= limit || (textField.unwrappedText.count + string.count) > limit
        if isExceed{
            showTextHUD("最多只能输入\(limit)位哦")
        }
        return !isExceed
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case phoneNumTF:
            passwordTF.becomeFirstResponder()
        default:
            if loginBtn.isEnabled{
                login(loginBtn)
            }
        }
        return true
    }
}
