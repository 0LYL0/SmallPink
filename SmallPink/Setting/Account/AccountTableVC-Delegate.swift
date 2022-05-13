//
//  AccountTableVC-Delegate.swift
//  SmallPink
//
//  Created by yalan on 2022/5/13.
//

import Foundation
extension AccountTableVC{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            if row == 0{
                showTextHUD("绑定,解绑,换绑手机号")
            }else if row == 1{
                if let _ = phoneNumStr{
                    performSegue(withIdentifier: "showPasswordTableVC", sender: nil)
                }else{
                    showTextHUD("请先绑定手机号哦")
                }
            }
        }else if section == 1{
            switch row {
            case 0:
                showTextHUD("绑定或解绑微信账号")
            case 1:
                showTextHUD("绑定或解绑微博账号")
            case 2:
                showTextHUD("绑定或解绑QQ账号")
            case 3:
                showTextHUD("绑定或解绑Apple账号")
            default:
                break
            }
        }
    }
}
