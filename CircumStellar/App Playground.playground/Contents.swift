//: Playground - noun: a place where people can play

import UIKit



        let minValue = //350//200 / 8 //self.size.width / 8
        let maxValue = //700//200 - 60 //self.size.width - 60
        let spawnPoint = UInt32( (maxValue - minValue) )


        for index in 1...10 {
            CGFloat(arc4random_uniform(spawnPoint))
        }



        