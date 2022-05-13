//
//  EditProfileTableVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/4.
//

import UIKit
import LeanCloud


class EditProfileTableVC: UITableViewController {
    
    var user: LCUser!
    var delegate: EditProfileTableVCDelegate?

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    
    var avatar: UIImage?{
        didSet{
            DispatchQueue.main.async {
                self.avatarImageView.image = self.avatar
            }
        }
    }
    var nickName = ""{
        didSet{
            nickNameLabel.text = nickName
        }
    }
    var gender = false{
        didSet{
//            guard let gender = gender else {
//                return
//            }
            genderLabel.text = gender ? "男" : "女"
        }
    }
    var birth: Date?{
        didSet{
            if let birth = birth {
                birthLabel.text = birth.format(with: "yyyy-MM-dd")
            }else{
                birthLabel.text = "未填写"
            }
        }
    }
    var intro = ""{
        didSet{
            introLabel.text = intro.isEmpty ? "未填写" : intro
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

//        textField.inputView = genderPickerView
//        tableView.addSubview(textField)
    }
    
    

    @IBAction func back(_ sender: Any) {
        delegate?.updateUser(avatar, nickName, gender, birth, intro)
        dismiss(animated: true)
    }
    
//    lazy var textField: UITextField = {
//        let textField = UITextField(frame: .zero)
//
//        return textField
//    }()
//
//    lazy var genderPickerView: UIStackView = {
//        let cancelBtn = UIButton()
//        setToolBarBtn(cancelBtn, title: "取消", color: .secondaryLabel)
//        let doneBtn = UIButton()
//        setToolBarBtn(doneBtn, title: "完成", color: mainColor)
//
//        let toolBarView = UIStackView(arrangedSubviews: [cancelBtn, doneBtn])
//        toolBarView.distribution = .equalSpacing
//
//        let pickerView = UIPickerView()
////        pickerView.translatesAutoresizingMaskIntoConstraints = false
////        pickerView.heightAnchor.constraint(equalToConstant: 100).isActive = true
//        pickerView.dataSource = self
//        pickerView.delegate = self
//
//        let genderPickerView = UIStackView(arrangedSubviews: [toolBarView, pickerView])
//        genderPickerView.frame.size.height = 150
//        genderPickerView.axis = .vertical
//        genderPickerView.spacing = 8
//        genderPickerView.backgroundColor = .secondarySystemBackground
//
//
//        return genderPickerView
//    }()
//    private func setToolBarBtn(_ btn: UIButton, title: String, color: UIColor){
//        btn.setTitle(title, for: .normal)
//        btn.titleLabel?.font = .systemFont(ofSize: 14)
//        btn.setTitleColor(color, for: .normal)
//        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
//    }
}

//extension EditProfileTableVC: UIPickerViewDataSource, UIPickerViewDelegate{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        2
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        ["男","女"][row]
//    }
//}
