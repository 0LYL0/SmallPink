//
//  CodeLoginVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/20.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        
        getAuthCodeBtn.isHidden = true
        loginBtn.setToDisabled()
        
        phoneNumTF.delegate = self
        

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        phoneNumTF.becomeFirstResponder()
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func TFEditingChange(_ sender: Any) {
        getAuthCodeBtn.isHidden = !phoneNumStr.isPhoneNum
    }
    
    
    @IBAction func getAuthCode(_ sender: Any) {
        getAuthCodeBtn.isEnabled = false
        getAuthCodeBtn.setTitle("重新发送(\(timeRemain)s)", for: .disabled)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(changeAuthCodeBtnText), userInfo: nil, repeats: true)
    }
    
    @IBAction func login(_ sender: Any) {
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
        }
    }
    
    
}
