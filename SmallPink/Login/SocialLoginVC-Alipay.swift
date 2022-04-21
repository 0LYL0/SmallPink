//
//  SocialLoginVC-Alipay.swift
//  SmallPink
//
//  Created by yalan on 2022/4/19.
//

import Foundation
import Alamofire
extension SocialLoginVC{
    func signInWithAlipy(){
        let infoStr = "apiname=com.alipay.account.auth&app_id=\(kAliPayAppID)&app_name=mc&auth_type=AUTHACCOUNT&biz_type=openservice&method=alipay.open.auth.sdk.code.get&pid=\(kAliPayPID)&product_id=APP_FAST_LOGIN&scope=kuaijie&sign_type=RSA2&target_id=20141225xxxx"
        
        guard let signer = APRSASigner(privateKey: kAliPayPrivateKey),
              let signedStr = signer.sign(infoStr, withRSA2: true) else { return }
        
        let authInfoStr = "\(infoStr)&sign=\(signedStr)"
        
        AlipaySDK.defaultService()?.auth_V2(withInfo: authInfoStr, fromScheme: kAppScheme){ res in
//            print(res)
            guard let res = res else { return }
            let resStatus = res["resultStatus"] as! String
            if resStatus == "9000"{
                let resStr = res["result"] as! String
                let resArr = resStr.components(separatedBy: "&")
                for subRes in resArr{
                    let equalIndex = subRes.firstIndex(of: "=")!
                    let equalEndIndex = subRes.index(after: equalIndex)
                    //                    let prefix = subRes[..<equalIndex]
                    let suffix = subRes[equalEndIndex...]
                    
                    if subRes.hasPrefix("auth_code"){
                        self.getToken(String(suffix))
                    }
                }
            }
            
        }
    }
}
extension SocialLoginVC{
    private func getToken(_ authCode: String){
        
        //                        print(suffix)
        
        let parameters = [
            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
            "method": "alipay.system.oauth.token",
            "app_id": kAliPayAppID,
            "sign_type": "RSA2",
            "version": "1.0",
            "charset": "utf-8",
            "grant_type": "authorization_code",
            "code": authCode
        ]
        
        
        
        AF.request("https://open.alipay.com/geteway.do", parameters: self.signedParameters(parameters)).responseDecodable(of: TokenResponse.self) { response in
            if let tokenResponse = response.value{
                let accessToken = tokenResponse.alipay_system_oauth_token_response.access_token
                
                self.getInfo(accessToken)
            }
        }
        
    }
    private func getInfo(_ accessToken: String){
        
        let parameters = [
            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
            "method": "alipay.user.info.share",
            "app_id": kAliPayAppID,
            "sign_type": "RSA2",
            "version": "1.0",
            "charset": "utf-8",
            "auth_token": accessToken
        ]
        AF.request("", parameters: self.signedParameters(parameters)).responseDecodable(of: InfoShareResponse.self) { response in
            if let infoShareResponse = response.value{
                let info = infoShareResponse.alipay_user_info_share_response
                print(info.nick_name)
            }
        }
    }
    
}
extension SocialLoginVC{
    private func signedParameters(_ parameters: [String: String]) -> [String: String]{
        var signedParameters = parameters
        let urlParameters = parameters.map{ "\($0)=\($1)" }.sorted().joined(separator: "&")
        guard let signer = APRSASigner(privateKey: kAliPayPrivateKey),
              let signedStr = signer.sign(urlParameters, withRSA2: true) else {
              fatalError("加签失败")
              }
        signedParameters["sign"] = signedStr.removingPercentEncoding ?? signedStr
        return signedParameters
    }
}

extension SocialLoginVC{
    struct TokenResponse: Decodable{
        let alipay_system_oauth_token_response: TokenResponseInfo
        
        struct TokenResponseInfo: Decodable{
            let access_token: String
        }
    }
    
    struct InfoShareResponse: Decodable{
        let alipay_user_info_share_response: InfoShareResponseInfo
        
        struct InfoShareResponseInfo: Decodable{
            let avatar: String
            let nick_name: String
            let gender: String
            let province: String
            let city: String
        }
    }
}
