//
//  NoteEditVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/11.
//

import UIKit
import CoreLocation


class NoteEditVC: UIViewController {
    
    var draftNote: DraftNote?
    
    var photos = [
        UIImage(named: "1")!, UIImage(named: "2")!
    ]
//    var videoURL: URL? = Bundle.main.url(forResource: "testVideo", withExtension: "mp4")
    var videoURL: URL?
    var channel = ""
    var subChannel = ""
    var poiName = ""
    
    
    var photoCount: Int{
        photos.count
    }
    var isVideo: Bool{
        videoURL != nil
    }
    var textViewIAView: TextViewIAView{
        textView.inputAccessoryView as! TextViewIAView
    }
    

    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleCountLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var channelIcon: UIImageView!
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var channelPlaceholderLabel: UILabel!
    
    @IBOutlet weak var poiNameLabel: UILabel!
    @IBOutlet weak var poiNameIcon: UIImageView!
    lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
       
    }
    func config(){
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.dragDelegate = self
        photoCollectionView.dropDelegate = self
        photoCollectionView.dragInteractionEnabled = true//开启拖拽交互
        
        titleTextField.delegate = self
        hideKeyboardWhenTappedAround()
        titleCountLabel.text = "\(kMaxNoteTitleCount)"
        
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -textView.textContainer.lineFragmentPadding, bottom: 0, right: -textView.textContainer.lineFragmentPadding)//去除文本边距
//        textView.textContainer.lineFragmentPadding = 0//去除内容缩进,左右边距
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        let typingAttributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: UIFont.systemFont(ofSize: 14),
            .foregroundColor: UIColor.secondaryLabel
        ]
        textView.typingAttributes = typingAttributes
        //光标颜色
        textView.tintColorDidChange()
        
//        if let textViewIAView = Bundle.main.loadNibNamed("TextViewIAView", owner: nil, options: nil)?.first as? TextViewIAView{
        
        textView.inputAccessoryView = Bundle.loadView(fromNib: "TextViewIAView", with: TextViewIAView.self)
        textViewIAView.doneBtn.addTarget(self, action: #selector(resignTextView), for: .touchUpInside)
        textViewIAView.maxTextCountLabel.text = "/\(kMaxNoteTextCount)"
//        }
        textView.delegate = self
        
        // MARK: 请求位置权限
        locationManager.requestWhenInUseAuthorization()
        AMapLocationManager.updatePrivacyShow(AMapPrivacyShowStatus.didShow, privacyInfo: AMapPrivacyInfoStatus.didContain)
        AMapLocationManager.updatePrivacyAgree(AMapPrivacyAgreeStatus.didAgree)
        
//        print(NSHomeDirectory())
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    }
    
    @objc private func resignTextView(){
        textView.resignFirstResponder()
    }
    
    @IBAction func TFEDitBegin(_ sender: Any) {
        titleCountLabel.isHidden = false
    }
    
    @IBAction func TFEditEnd(_ sender: Any) {
        titleCountLabel.isHidden = true
    }
    
    @IBAction func TFEditOnExit(_ sender: Any) {
    }
    
    @IBAction func TFEditChanged(_ sender: Any) {
        guard titleTextField.markedTextRange == nil else { return }
        if titleTextField.unwrappedText.count > kMaxNoteTitleCount{
            titleTextField.text = String(titleTextField.unwrappedText.prefix(kMaxNoteTitleCount))
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
            DispatchQueue.main.async {
                let end = self.titleTextField.endOfDocument
                self.titleTextField.selectedTextRange = self.titleTextField.textRange(from: end, to: end)
            }
        }
        titleCountLabel.text = "\(kMaxNoteTitleCount - titleTextField.unwrappedText.count)"
    }
    
    @IBAction func saveDraftNote(_ sender: Any) {
        
        guard textViewIAView.currentTextCount <= kMaxNoteTextCount else {
            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
            return
        }
        let draftNote = DraftNote(context: context)
        if isVideo{
            draftNote.video = try? Data(contentsOf: videoURL!)
        }
        draftNote.coverPhoto = photos[0].jpeg(.high)

        var photos: [Data] = []
        for photo in self.photos {
            if let pngData = photo.pngData(){
                photos.append(pngData)
            }
        }
        draftNote.photos = try? JSONEncoder().encode(photos)
        
        draftNote.isVideo = isVideo
        draftNote.title = titleTextField.exactText
        draftNote.text = textView.exactText
        draftNote.channel = channel
        draftNote.subChannel = subChannel
        draftNote.poiName = poiName
        draftNote.updateAt = Date()
        
        appDelegate.saveContext()
    }
    
    @IBAction func postNote(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let channelVC = segue.destination as? ChannelVC{
            view.endEditing(true)
            channelVC.PVDelegate = self
        }else if let POIVC = segue.destination as? POIVC{
            POIVC.delegate = self
            POIVC.poiName = self.poiName
        }
    }
}

extension NoteEditVC: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        guard textView.markedTextRange == nil else { return }
        textViewIAView.currentTextCount = textView.text.count
    }
}


extension NoteEditVC: UITextFieldDelegate{
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if range.location >= kMaxNoteTitleCount || (textField.unwrappedText.count + string.count) > kMaxNoteTitleCount{
//            showTextHUD("标题最多输入\(kMaxNoteTitleCount)字")
//            return false
//        }
//        return true
//    }
}

extension NoteEditVC: ChannelVCDelegate{
    func updateChannel(channel: String, subChannel: String){
        print(channel, subChannel)
        self.channel = channel
        self.subChannel = subChannel
        channelLabel.text = subChannel
        channelIcon.tintColor = blueColor
        channelLabel.textColor = blueColor
        channelPlaceholderLabel.isHidden = true
    }
}

extension NoteEditVC: POIVCDelegate{
    func updatePOIName(_ name: String) {
        if name == kPOIsInitArr[0][0]{
            poiName = ""
            poiNameIcon.tintColor = .label
            poiNameLabel.text = "添加地点"
            poiNameLabel.textColor = .label
        }else{
            self.poiName = name
            poiNameLabel.text = self.poiName
            poiNameLabel.textColor = blueColor
            poiNameIcon.tintColor = blueColor
        }
    }
}


