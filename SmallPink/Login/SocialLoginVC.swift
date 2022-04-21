//
//  SocialLoginVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/19.
//

import UIKit
import AuthenticationServices

class SocialLoginVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signInWithAlipay(_ sender: Any) {
        signInWithAlipy()
    }
    
    @IBAction func signInWithApple(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    

}
