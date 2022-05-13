//
//  PasswordTableVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/13.
//

import UIKit
import LeanCloud

class PasswordTableVC: UITableViewController {
    
    var user: LCUser!
    var setPasswordFinished: (() ->())?

    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var newPasswordTF: UITextField!
    
    private var passwordStr: String{ passwordTF.unwrappedText }
    private var newPasswordStr: String{ newPasswordTF.unwrappedText }
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordTF.delegate = self
        newPasswordTF.delegate = self
        passwordTF.becomeFirstResponder()
    
    }

    @IBAction func done(_ sender: UIButton) {
        if passwordStr.isPassword && newPasswordStr.isPassword{
            if passwordStr == newPasswordStr{
                //云端
                user.password = LCString(passwordStr)
                try? user.set(kIsSetPasswordCol, value: true)
                user.save{ _ in }
                
                //UI
                dismiss(animated: true)
                setPasswordFinished?()
            }else{
                showTextHUD("两次密码不一致")
            }
        }else{
            showTextHUD("密码必须为6-16位的数字或字母")
        }
    }
    
    @IBAction func TFEditChanged(_ sender: Any) {
        if passwordTF.isBlank || newPasswordTF.isBlank{
            doneBtn.isEnabled = false
        }else{
            doneBtn.isEnabled = true
        }
    }
}
extension PasswordTableVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField{
        case passwordTF:
            newPasswordTF.becomeFirstResponder()
        default:
            if doneBtn.isEnabled{
                done(doneBtn)
            }
        }
        return true
    }
}
