//
//  AccountTableVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/13.
//

import UIKit
import LeanCloud

class AccountTableVC: UITableViewController {
    
    var user: LCUser!
    var phoneNumStr: String? { user.mobilePhoneNumber?.value }
    var isSetPassword: Bool? { user.get(kIsSetPasswordCol)?.boolValue }

    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var appleIDLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        if let phoneNumStr = phoneNumStr {
            phoneNumLabel.setToLight(phoneNumStr)
        }
        if let _ = isSetPassword{
            passwordLabel.setToLight("已设置")
        }
        if let authData = user.authData?.value{
            let keys = authData.keys
            if keys.contains("lc_apple"){
                appleIDLabel.setToLight(user.getExactStringVal(kNickNameCol))
            }
        }
      
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let passwordTableVC = segue.destination as? PasswordTableVC{
            passwordTableVC.user = user
            if isSetPassword == nil{
                passwordTableVC.setPasswordFinished = {
                    self.passwordLabel.setToLight("已设置")
                }
            }
        }
    }

}
