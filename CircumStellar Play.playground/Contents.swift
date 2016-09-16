//: Playground - noun: a place where people can play

import UIKit
import XCPlayground

var str = "Hello, playground"



//: Playground - noun: a place where people can play




let minValue = 350//200 / 8 //self.size.width / 8
let maxValue = 700//200 - 60 //self.size.width - 60
let spawnPoint = UInt32( (maxValue - minValue) )


for index in 1...10 {
    CGFloat(arc4random_uniform(spawnPoint))
}


//func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
//    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
//}





randomBetweenNumbers(0, secondNum: frame.width)