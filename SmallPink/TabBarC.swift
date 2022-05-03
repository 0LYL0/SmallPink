//
//  TabBarC.swift
//  SmallPink
//
//  Created by yalan on 2022/4/10.
//

import UIKit
import YPImagePicker
import LeanCloud

class TabBarC: UITabBarController, UITabBarControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PostVC{
            
            if let _ = LCApplication.default.currentUser{
                var config = YPImagePickerConfiguration()
                
                // MARK: 通用配置
                config.isScrollToChangeModesEnabled = false //取消滑动切换，防止和编辑相册图片时的手势冲突
                config.onlySquareImagesFromCamera = false //是否只让拍摄正方形照片
                config.albumName = Bundle.main.appName //存图片进相册App的'我的相簿'里的文件夹名称
                config.startOnScreen = .library //一打开就展示相册
                config.screens = [.library, .video, .photo] //依次展示相册，拍视频，拍照页面
                config.maxCameraZoomFactor = 5 //最大多少倍变焦
    //            config.showsVideoTrimmer = false
                
                //小红书的照片和视频逻辑:
                //1.照片和视频不可混排,且在相册中多选的视频最后会帮我们合成一个视频(即最终只能有一个视频)
                //2.无论是相册照片还是现拍照片,之后在编辑页面皆可追加
                //总结:允许一个笔记发布单个视频或多张照片
                
                // MARK: 相册配置
                config.library.defaultMultipleSelection = true //是否可多选
                config.library.maxNumberOfItems = kMaxPhotoCount //最大选取照片或视频数
                config.library.spacingBetweenItems = kSpacingBetweenItems //照片缩略图之间的间距
                
                // MARK: 视频配置(参照文档,此处全部默认)
                
                // MARK: - Gallery(多选完后的展示和编辑页面)-画廊
                config.gallery.hidesRemoveButton = false //每个照片或视频右上方是否有删除按钮
                
                
                let picker = YPImagePicker(configuration: config)
                
                // MARK: 选完或按取消按钮后的异步回调处理（依据配置处理单个或多个）
                picker.didFinishPicking { [unowned picker] items, cancelled in
                    if cancelled{
    //                    print("用户按了左上角的取消按钮")
                        picker.dismiss(animated: true, completion: nil)
                    }else{
                        var photos: [UIImage] = []
                        var videoURL: URL?
                        
                        for item in items{
                            switch item {
                            case let .photo(photo):
    //                            print(photo)
                                photos.append(photo.image)
                            case .video(let video):
    //                            print(video)
                                photos.append(video.thumbnail)
                                videoURL = video.url
                                
    //                            let url = URL(fileURLWithPath: "recordedVideoRAW.mov", relativeTo: FileManager.default.temporaryDirectory)
    //                            photos.append(url.thumbnail)
    //                            videoURL = url
                            }
                        }
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: kNoteEditVCID) as! NoteEditVC
                        vc.photos = photos
                        vc.videoURL = videoURL
                        picker.pushViewController(vc, animated: true)
                    }
                }
                
                present(picker, animated: true, completion: nil)
            }else{
                let alert = UIAlertController(title: "提示", message: "需要先登录哦", preferredStyle: .alert)
                let action1 = UIAlertAction(title: "再看看", style: .cancel, handler: nil)
                let action2 = UIAlertAction(title: "去登录", style: .default) { _ in
                    tabBarController.selectedIndex = 4
                }
                alert.addAction(action1)
                alert.addAction(action2)
                present(alert,animated: true, completion: nil)
            }
            return false
        }
    
        return true
        
    }

}
