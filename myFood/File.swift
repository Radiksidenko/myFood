//
//  File.swift
//  myFood
//
//  Created by Radomyr Sidenko on 07.06.2018.
//  Copyright © 2018 Radomyr Sidenko. All rights reserved.
//

import Foundation
var s1 : String! = readLine()
var s2 : String! = readLine()

var a = Array(s1)
var b = Array(s2)
var c : String = ""

func test(){
    if (a.count == b.count) {
        for i in 0..<a.count {
            if a[i] != b[i] {
                c.append("s")
            }
        }
    }
    if a.count > b.count {
        for i in 0..<b.count {
            if a[i] != b[i] {
                c.append("s")
            }
        }
        var g = a.count - b.count
        while g != 0 {
            c.append("d")
            g = g - 1
        }
    }
    if a.count < b.count {
        for i in 0..<a.count {
            if a[i] != b[i] {
                if a.count != b.count {
                    a.insert(b[i], at: i)
                    c.append("i")
                } else {
                    c.append("s")
                }
            }
        }
    }
    
    print(c)
}
