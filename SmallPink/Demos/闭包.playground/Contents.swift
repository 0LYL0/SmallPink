import UIKit

// MARK: - 语法一:代码执行块
//{ (parameters) -> return type in
//    statements
//}

//直接调用
let label: UILabel = {
    let label = UILabel()
    label.text = "xxx"
    return label
}()

//先定义,后调用
let learn = { (lan: String) -> String in
    "学习\(lan)"
}
learn("iOS")

//和函数区别
func learn1(_ lan: String) -> String{
    "学习\(lan)"
}
learn1("iOS")

//定义类型
let aa: Int?
let bb: (() -> ())?
let cc: (() -> Void)?

// MARK: - 嵌套函数: 作为另外一个函数的参数或返回值
func codingSwift(day: Int, appName: () -> String){
    print("学习swift\(day)天了,做了\(appName())App")
}
//传参时直接写闭包
codingSwift(day: 30, appName: { () -> String in
    "天气"
})
//传参时已经写好了闭包名
let appName1 = { () -> String in
    "备忘录"
}
codingSwift(day: 40, appName: appName1)
//传参时已经写好了函数名,需参数和返回值的个数和类型完全一样
func appName2() -> String{
    "计算器"
}
codingSwift(day: 50, appName: appName2)

// MARK: - 闭包简写1,尾随闭包Trailing Closure
codingSwift(day: 60) { () -> String in
    "机器学习"
}

// MARK: - 闭包简写2,根据上下文推断类型
func codingSwift(day: Int, appName: String, res: (Int, String) -> String){
    print("学习swift\(day)天了,\(res(1, "Almofire")),做成了\(appName)App")
}
codingSwift(day: 80, appName: "天气") { takeDay, use in
    "花了\(takeDay)天,使用了\(use)技术"
}

// MARK: - 系统函数案例--sorted
let arr = [3,5,2,1,4]
let sortedArr = arr.sorted(by: <)
//https://juejin.cn/post/6844903856900407304

// MARK: - 闭包捕获
func makeIncrementer(forINcrement amount: Int) -> () -> Int{
    var runningTotal = 0
    let incrementer = { () -> Int in
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forINcrement: 10)
incrementByTen()//10
incrementByTen()//20
incrementByTen()//30

let incrementBySeven = makeIncrementer(forINcrement: 7)
incrementBySeven()//7

incrementByTen() //40

// MARK: - 闭包是引用类型
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen()//50

incrementByTen()//60

// MARK: - 逃逸闭包(@escaping)
var completionHandlers: [() -> ()] = []
func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void){
    completionHandlers.append(completionHandler)
}
func someFunctionWithNonescapingClosure(closure: () -> Void){
    closure()
}

class SomeClass{
    var x = 10
    func doSomething(){
        someFunctionWithEscapingClosure {
            self.x = 100
        }
        someFunctionWithNonescapingClosure {
            x = 200
        }
    }
}

let instance = SomeClass()
instance.doSomething()
print(instance.x)

completionHandlers.first?()
print(instance.x)

//实际应用
class SomeVC{
    func getData(finished: @escaping (String) -> ()){
        print("外层函数开始执行")
        DispatchQueue.global().async {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                finished("我是数据")
            }
        }
        print("外层函数执行结束")
    }
}

let someVC = SomeVC()
someVC.getData { data in
    print("逃逸闭包执行,拿到了耗时任务过来的数据--\(data),可以做一些其他处理")
}
