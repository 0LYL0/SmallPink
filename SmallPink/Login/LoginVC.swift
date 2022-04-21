//
//  LoginVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/18.
//

import UIKit

class LoginVC: UIViewController {
    
    lazy private var loginBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = mainColor
        btn.layer.cornerRadius = 22
        btn.addTarget(self, action: #selector(localLogin), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loginBtn)
        setUI()
        // Do any additional setup after loading the view.
    }
    
    private func setUI(){
        loginBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginBtn.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
