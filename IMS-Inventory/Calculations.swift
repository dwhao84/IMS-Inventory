//
//  Calculations.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/10.
//

import UIKit

// 確認是否貨架是連在一起的
var isConnected: Bool  = false
// 確認是否貨架是Single side還Double side的
var isDoubleSide: Bool = false
var nintySec: Int = 3
var sixtySec: Int = 1
var depth: Int = 20

// MARK: -
public func calculationBracketsAndShelfs () {
    
    // 只有W600 sections，並沒有連結
    if nintySec.isMultiple(of: 0) && isConnected == false {
    // 如果不是Double side
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySec * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 4)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySec * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 4)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySec * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 4)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySec * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 4)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySec * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 4)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySec)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 2)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySec)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 2)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySec)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 2)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySec)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 2)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySec)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 2)")
            default:
                break
            }
        }
        
    // 只有W600 sections，並且連結在一起
    } else if nintySec.isMultiple(of: 0) && isConnected == true {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySec * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 6)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySec * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 6)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySec * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 6)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySec * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 6)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySec * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 6)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySec)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 3)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySec)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 3)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySec)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 3)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySec)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 3)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySec)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySec * 3)")
            default:
                break
            }
        }
        
    // 只有W900的時候，並沒有連結
    } else if sixtySec.isMultiple(of: 0) && isConnected == false {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySec)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySec)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySec)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySec)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySec)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySec * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 4)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySec * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 4)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySec * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 4)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySec * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 4)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySec * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 4)")
            default:
                break
            }
        }
        
    // 只有W900 sections，並且連結在一起
    } else if sixtySec.isMultiple(of: 0)  && isConnected == true {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySec * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 6)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySec * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 6)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySec * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 6)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySec * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 6)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySec * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySec * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 6)")
            default:
                break
            }
        } else {
            print("Single Side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySec)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySec)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySec)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySec)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySec)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySec * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySec * 2)")
            default:
                break
            }
        }
    } else if nintySec > 0 && sixtySec > 0 && isConnected == false {
        
        
    } else if nintySec > 0 && sixtySec > 0 && isConnected == true {
        
        
    } else {
        
    }
}

