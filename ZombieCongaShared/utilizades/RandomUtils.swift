//
//  RandomUtils.swift
//  ZombiConga
//
//  Created by admin on 10/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import CoreGraphics

class RandomUtils: NSObject {

}

extension CGFloat{
    
    static func random()-> CGFloat{
        //random devuelve un valor aleatorio entre -1 y 1
        //se divide por el mayor numero que se quiere conseguir.
        //en este caso le damos el entero mas grande posible, UInt32.max es dos mil millones y pico.
        return CGFloat(Float(arc4random()) / Float(UInt32.max))
    }
    
    static func random(min: CGFloat, max: CGFloat)-> CGFloat{
        assert(min < max)
        //devuelve valo aleatorio entre un min y un max
        return CGFloat.random() * (max - min) + min
    }
}
