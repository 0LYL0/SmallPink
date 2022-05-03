//
//  NoteEditVC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/11.
//

import UIKit
import CoreLocation
import LeanCloud


class NoteEditVC: UIViewController {
    
    var draftNote: DraftNote?
    var updateDraftNoteFinished: (() -> ())?
    var postDraftNoteFinished: (() -> ())?
    
    var note: LCObject?
    var updateNoteFinished: ((String) -> ())?
    
    var photos: [UIImage] = []
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
        setUI()
       
    }
    @objc func resignTextView(){
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
    // MARK: 保存草稿
    @IBAction func saveDraftNote(_ sender: Any) {
        
        guard isValidateNote() else { return }
        
        if let draftNote = draftNote {//更新草稿
            updateDraftNote(draftNote)
        }else{//创建草稿
            creatDraftNote()
        }
       
    }
    // MARK: 发布到云端
    @IBAction func postNote(_ sender: Any) {
        guard isValidateNote() else { return }
        if let draftNote = draftNote {//发布草稿笔记
            postDraftNote(draftNote)
        }else if let note = note {//更新笔记
            updateNote(note)
        }else{//发布新笔记
            createNote()
        }
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
        updateChannelUI()
    }
}

extension NoteEditVC: POIVCDelegate{
    func updatePOIName(_ name: String) {
        if name == kPOIsInitArr[0][0]{
            poiName = ""
        }else{
            self.poiName = name
        }
        updatePOINameUI()
    }
}


