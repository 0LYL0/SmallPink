//
//  Protocols.swift
//  SmallPink
//
//  Created by yalan on 2022/4/12.
//

import Foundation

protocol ChannelVCDelegate {
    /// 用户从选择话题页
    /// - Parameter channel: 传回来的channel
    /// - Parameter subChannel: 传回来的subChannel
    func updateChannel(channel: String, subChannel: String)
    
}


protocol POIVCDelegate{
    func updatePOIName(_ name: String)
}

protocol IntroVCDelegate{
    func updateIntro(_ intro: String)
}

protocol EditProfileTableVCDelegate{
    func updateUser(_ avatar: UIImage?, _ nickName: String, _ gender: Bool, _ birth: Date?, _ intro: String)
}
