import UIKit

//解决方法:weak(弱引用)和unowned(无主引用)
class Author{
    var name: String
    weak var video: Video?
    init(name: String){
        self.name = name
    }
    deinit{
        print("author对象被销毁了")
    }
}

class Video{
    weak var author: Author?
    init(author: Author){
        self.author = author
    }
    deinit{
        print("video对象被销毁了")
    }
}

var author: Author? = Author(name: "nene")
var video: Video? = Video(author: author!)
author?.video = video

author = nil
video = nil
