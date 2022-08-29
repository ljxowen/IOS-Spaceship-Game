//
//  PhysicsCategory.swift
//  liux8550_a5
//
//  Created by jingxuan liu on 2021-03-25.
//

import Foundation
struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Invader   : UInt32 = 0b1       // 1
    static let playerBullet: UInt32 = 0b10      // 2
    static let Spaceship: UInt32 = UInt32(3)   //3
    static let invaderRock: UInt32 = UInt32(4)  //4
    static let shelters: UInt32 = UInt32(5)        //5
}
