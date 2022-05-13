//
//  SettingTableVC.swift
//  SmallPink
//
//  Created by yalan on 2022/5/10.
//

import UIKit
import Kingfisher
import LeanCloud

class SettingTableVC: UITableViewController {
    
    var user: LCUser!

    @IBOutlet weak var cacheSizeLabel: UILabel!
    
    var cacheSizeStr = kNoCachePH{
        didSet{
            DispatchQueue.main.async {
                self.cacheSizeLabel.text = self.cacheSizeStr
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageCache.default.calculateDiskStorageSize { res in
            if case let .success(size) = res{
//                var cacheSize = ""
//                if size > 0{
//                    if size < 1024{
//                        cacheSize = "\(size) B"
//                    }else{
//                        if size < 1048576{
//                            cacheSize = "\(size / 1024) KB"
//                        }else{
//                            if size < 1073741824{
//                                cacheSize = "\(size / 1048576) MB"
//                            }else{
//                                cacheSize = "\(size / 1073741824) GB"
//                            }
//                        }
//                    }
//                }else{
//                    cacheSize = "无缓存"
//                }
                var cacheSizeStr: String{
                    guard size > 0 else { return kNoCachePH }
                    guard size >= 1024 else { return "\(size) B" }
                    guard size >= 1048576 else { return "\(size / 1024) KB" }
                    guard size >= 1073741824 else { return "\(size / 1048576) MB" }
                    return "\(size / 1073741824) GB"
                }
                self.cacheSizeStr = cacheSizeStr
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let accountTableVC = segue.destination as? AccountTableVC{
            accountTableVC.user = user
        }
    }

}
