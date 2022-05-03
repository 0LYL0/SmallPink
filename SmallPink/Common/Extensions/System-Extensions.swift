//
//  Extensions.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import UIKit
import AVFoundation
import MBProgressHUD
import DateToolsSwift

extension Int{
    var formattedStr: String{
        let num = Double(self)
        let tenThousand = num / 10_000
        let hundredMillion = num / 100_000_000
        if tenThousand < 1{
            return "\(self)"
        }else if hundredMillion >= 1{
            return "\(round(hundredMillion * 10) / 10)亿"
        }else{
            return "\(round(tenThousand * 10) / 10)万"
        }
    }
}

extension String{
    var isBlank: Bool{
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isPhoneNum: Bool{
        Int(self) != nil && NSRegularExpression(KPhoneRegEx).matches(self)
    }
    var isAuthCode: Bool{
        Int(self) != nil && NSRegularExpression(KAuthCodeRegEx).matches(self)
    }
    static func randomString(_ length: Int) -> String{
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{_ in letters.randomElement()! })
    }
    func spliceAttrStr(_ dateStr: String) -> NSMutableAttributedString{
        let attrText = toAttrStr()
        let attrDate = " \(dateStr)".toAttrStr(12, .secondaryLabel)
        
        attrText.append(attrDate)
        return attrText
    }
    func toAttrStr(_ fontSize: CGFloat = 14, _ color: UIColor = .label) -> NSMutableAttributedString{
        let attr: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: fontSize),
            .foregroundColor: color
        ]
        return NSMutableAttributedString(string: self, attributes: attr)
    }
}
extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            fatalError("非法的正则表达式")//因不能确保调用父类的init函数
        }
    }
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
}

extension Optional where Wrapped == String{
    var unwrappedText: String{
        self ?? ""
    }
}

extension Date{
    var formatterDate: String{
        let currentYear = Date().year
        if year == currentYear{
            if isToday{
                if minutesAgo > 10{
                    return "今天 \(format(with: "HH:mm"))"
                }else{
                    return timeAgoSinceNow
                }
            }else if isYesterday{
                return "昨天 \(format(with: "HH:mm"))"
            }else{
                return format(with: "MM-dd")
            }
        }else if year < currentYear{
            return format(with: "yyyy-MM-dd")
        }else{
            return "明年或更远"
        }
    }
}
extension URL{
    //从视频中生成封面图(了解)
    var thumbnail: UIImage{
        let asset = AVAsset(url: self)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //如果视频尺寸确定的话可以用下面这句提高处理性能
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            return imagePH
        }
    }
}

extension UIButton{
    func setToEnabled(){
        isEnabled = true
        backgroundColor = mainColor
    }
    
    func setToDisabled(){
        isEnabled = false
        backgroundColor = mainLightColor
    }
    
    func makeCapsule(_ color: UIColor = .label){
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = color.cgColor
    }
}

extension UIImage{
    
    convenience init?(_ data: Data?){
        if let unwrappedData = data{
            self.init(data: unwrappedData)
        }else{
            return nil
        }
    }
    
    enum JPEGQuality: CGFloat{
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    func jpeg(_ jpegQuality: JPEGQuality) -> Data?{
        jpegData(compressionQuality: jpegQuality.rawValue)
    }
}

extension UITextField{
    var unwrappedText: String{
        text ?? ""
    }
    var exactText: String{
        unwrappedText.isBlank ? "" : unwrappedText
    }
    var isBlank: Bool { unwrappedText.isBlank }
}
extension UITextView{
    var unwrappedText: String{
        text ?? ""
    }
    var exactText: String{
        unwrappedText.isBlank ? "" : unwrappedText
    }
    var isBlank: Bool { unwrappedText.isBlank }
}

extension UIView{
    @IBInspectable
    var radius: CGFloat{
        get{
            layer.cornerRadius
        }
        set{
            clipsToBounds = true
            layer.cornerRadius = newValue
        }
    }
}
extension UIAlertAction{
    func setTitleColor(_ color: UIColor){
        setValue(color, forKey: "titleTextColor")
    }
    var titleTextColor: UIColor? {
        get{
            value(forKey: "titleTextColor") as? UIColor
        }
        set{
            setValue(newValue, forKey: "titleTextColor")
        }
    }
}

extension UIViewController{
    
    // MARK: 提示框-手动隐藏
    func showLoadHUD(_ title: String? = nil){
        let hub = MBProgressHUD.showAdded(to: view, animated: true)
        hub.label.text = title
    }
    func hideLoadHUD(){
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // MARK: 提示框-自动隐藏
    func showTextHUD(_ title: String,_ inCurrentView: Bool = true, _ subTitle: String? = nil){
        var viewToShow = view!
        if !inCurrentView{
            viewToShow = UIApplication.shared.windows.last!
        }
        let hud = MBProgressHUD.showAdded(to: viewToShow, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }
    func showLoginHUD(){
        showLoginHUD()
    }
    func showTextHUD(_ title: String, in view: UIView, _ subTitle: String? = nil){
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = .text
        hud.label.text = title
        hud.detailsLabel.text = subTitle
        hud.hide(animated: true, afterDelay: 2)
    }
    
    // MARK: 点击空白收起软键盘
    func hideKeyboardWhenTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard(){
        view.endEditing(true)
    }
    
    func add(child vc: UIViewController){
        addChild(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }
    func remove(child vc: UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    func removeChildren(){
        if !children.isEmpty{
            for vc in children{
                remove(child: vc)
            }
        }
    }
    
    
}

extension Bundle{
    var appName: String{
        if let appName = localizedInfoDictionary?["CFBundleDisplayName"] as? String{
            return appName
        }else{
            return infoDictionary!["CFBundleDisplayName"] as! String
        }
    }
    
    static func loadView<T>(fromNib name: String, with type: T.Type) -> T{
       if let view = Bundle.main.loadNibNamed(name, owner: nil, options: nil)?.first as? T{
           return view
       }
       fatalError("加载\(type)类型的view失败")
    }
}

extension FileManager{
    func save(_ data: Data?, to dirName: String, as fileName: String) -> URL?{
        guard let data = data else {
            print("要写入本地的data为nil")
            return nil
        }
        //file:///xx/xx/tmp/dirName
        let dirURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(dirName, isDirectory: true)
        if !fileExists(atPath: dirURL.path){
            guard let _ = try? createDirectory(at: dirURL, withIntermediateDirectories: true) else{
                print("创建文件夹失败")
                return nil
            }
        }
        //file:///xx/xx/tmp/dirName/fileName
        let fileURL = dirURL.appendingPathComponent(fileName)
        if !fileExists(atPath: fileURL.path){
            guard let _ = try? data.write(to: fileURL) else{
                print("写入文件失败")
                return nil
            }
        }
        return fileURL
    }
}
// MARK: UserDefaults
extension UserDefaults{
    static func increase(_ key: String, by val: Int = 1){
        standard.set(standard.integer(forKey: key) + val, forKey: key)
    }
    static func decrease(_ key: String, by val: Int = 1){
        standard.set(standard.integer(forKey: key) - val, forKey: key)
    }
}
