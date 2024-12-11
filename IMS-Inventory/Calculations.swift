//
//  Calculations.swift
//  IMS-Inventory
//
//  Created by Dawei Hao on 2024/12/10.
//

import UIKit

public func calculateRacking(nintySectionQty: Int, sixtySectionQty: Int, isSingleSide: Bool = true) {
    // Constants
    let nintySection: Int = 90
    let sixtySection: Int = 60
    let additionalLength: Int = 0
    
    // Calculate floor rail length
    let floorFullLength = (nintySection * nintySectionQty + sixtySection * sixtySectionQty + additionalLength)
    print("The whole section is \(floorFullLength) cm")
    
    let divideNumbers = (floorFullLength / 197)
    let afterDivideNum = (floorFullLength % 197)
    
    if floorFullLength < 197 {
        print("\(floorFullLength)cm * 1")
        print("The 90's section is \(nintySectionQty), the 60's section is \(sixtySectionQty) sections")
    } else {
        print("197cm * \(divideNumbers) + \(afterDivideNum)cm * 1")
        print("The 90's section is \(nintySectionQty), the 60's section is \(sixtySectionQty) sections")
    }
    
    // Calculate accessories
    let postOfUprightQty = (nintySectionQty + sixtySectionQty) + 1
    print("15525 * \(postOfUprightQty)")
    print("50033 * \(postOfUprightQty)")
    print("14011 * \(postOfUprightQty)")
    
    if nintySectionQty == 0 {
        // sixty section
        print("19441 * \(sixtySectionQty)")
        print("10646 * \(sixtySectionQty)")
        
    } else if sixtySectionQty == 0 {
        // ninty section
        print("17696 * \(nintySectionQty)")
        print("10647 * \(nintySectionQty)")
        
    } else {
        // ninty section
        print("17696 * \(nintySectionQty)")
        print("10647 * \(nintySectionQty)")
        // sixty section
        print("19441 * \(sixtySectionQty)")
        print("10646 * \(sixtySectionQty)")
    }
    
    let bracketForBackPanelHolderMiddleQty = (nintySectionQty + sixtySectionQty) * 2
    print("10637 * \(bracketForBackPanelHolderMiddleQty)")
    
    if isSingleSide && nintySectionQty == 0 {
        print("section 1")
        if sixtySectionQty >= 2 {
            print("21963 * \(sixtySectionQty - 1)")
            print("10648 * 2")
            print("10600 * \(sixtySectionQty)")
        } else {
            print("10648 * \(sixtySectionQty * 2)")
        }
        
        // Only sixty section
        print("10641 * \(sixtySectionQty)")
        print("10639 * \(sixtySectionQty)")
        
    } else if isSingleSide && sixtySectionQty == 0 {
        print("section 2")
        if nintySectionQty >= 2 {
            print("21962 * \(nintySectionQty - 1)")
            print("10664 * 2")
            print("10600 * \(nintySectionQty)")
        } else {
            print("10664 * \(nintySectionQty * 2)")
        }
        
        // Only ninty section
        print("10642 * \(nintySectionQty)")
        print("10640 * \(nintySectionQty)")
        
    } else if !isSingleSide && sixtySectionQty == 0 {
        print("section 3")
        if nintySectionQty >= 2 {
            print("21962 * \(nintySectionQty - 1)")
            print("10664 * 2")
            print("10600 * \(nintySectionQty)")
        } else {
            print("10664 * \(nintySectionQty * 2)")
        }
        
        // Only ninty section
        print("10642 * \(nintySectionQty * 1)")
        print("10640 * \(nintySectionQty * 1)")
        
    } else if !isSingleSide && nintySectionQty == 0 {
        print("section 4")
        if sixtySectionQty >= 2 {
            print("21963 * \(sixtySectionQty - 1)")
            print("10648 * 2")
            print("10600 * \(sixtySectionQty)")
        } else {
            print("10648 * \(sixtySectionQty * 2)")
        }
        
        // Only sixty section
        print("10641 * \(sixtySectionQty * 2)")
        print("10639 * \(sixtySectionQty * 2)")
        
    } else {
        print("section 5")
        // ninty section
        print("10642 * \(nintySectionQty * 1)")
        print("10640 * \(nintySectionQty * 1)")
        
        // sixty section
        print("10641 * \(sixtySectionQty * 1)")
        print("10639 * \(sixtySectionQty * 1)")
        
        print("21962, 21963, 10664, 10648 need to calculate by yourself!!!")
    }
    
    print("80080 * \(Double(floorFullLength/197)) + \(floorFullLength % 197)cm * 1")
}


func calculateShelvingSystem(
    nintySection: Int = 0,
    sixtySection: Int = 0,
    height: Int = 2480,
    qtyOfShelf: Int = 9,
    withBase: Bool = false
) {
    // 只有 60 sections
    if nintySection == 0 && sixtySection >= 1 {
        print("50167 SHELF PERFORATED METAL F SHELVING SYSTEM D598 W618MM WHI * \(qtyOfShelf)")
        print("50168 SHELF SUPPORT F SHELF PERFORATED METAL F SHELVING SYSTEM L584MM GALV * \(qtyOfShelf * 2 - sixtySection * 2)")
        
        switch height {
        case 854:
            print("50216 Left side unit f shelving system D600 H854MM whi * \(sixtySection)")
            print("50217 Middle unit f shelving system D600 H854MM whi * \(sixtySection)")
            print("50218 Right side unit f shelving system D600 H854MM whi * \(sixtySection)")
            print(" =========== ")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            
        case 1340:
            print("50213 Left side unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("50215 Right side unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print(" =========== ")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            
        case 2480:
            print("50210 Left side unit f shelving system D600 H2480 whi * \(sixtySection)")
            print("50211 Middle unit f shelving system D600 H2480 whi * \(sixtySection)")
            print("50212 Right side unit f shelving system D600 H2480 whi * \(sixtySection)")
            print(" =========== ")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            print(" =========== ")
            print("50190 Ceiling support 680MM f shelving system whi * 2")
            print("50188 Ceiling support clamp f shelving system whi * 2")
            
        default:
            break
        }
    }
    
    // 只有 90 sections
    else if sixtySection == 0 && nintySection >= 1 {
        print("50187 SHELF MESH F SHELVING SYSTEM D898 W618MM WHI * \(qtyOfShelf)")
        print("50184 SHELF SUPPORT F SHELVING SYSTEM L884MM WHI * \(qtyOfShelf * 2 - nintySection * 2)")
        
        switch height {
        case 854:
            print("50216 Left side unit f shelving system D600 H854MM whi * 1")
            print("50217 Middle unit f shelving system D600 H854MM whi * \(nintySection)")
            print("50218 Right side unit f shelving system D600 H854MM whi * 1")
            print(" =========== ")
            print("50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)")
            
        case 1340:
            print("50213 Left side unit f shelving system D600 H1304MM whi * 1")
            print("50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("50215 Right side unit f shelving system D600 H1304MM whi * 1")
            print(" =========== ")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            
        case 2480:
            print("50210 Left side unit f shelving system D600 H2480 whi * 1")
            print("50211 Middle unit f shelving system D600 H2480 whi * \(nintySection)")
            print("50212 Right side unit f shelving system D600 H2480 whi * 1")
            print(" =========== ")
            print("50190 Ceiling support 680MM f shelving system whi * 2")
            print("50188 Ceiling support clamp f shelving system whi * 2")
            
        default:
            break
        }
    }
    
    // 同時有 90 和 60 sections
    else if nintySection >= 1 && sixtySection >= 1 {
        print("50167 SHELF PERFORATED METAL F SHELVING SYSTEM D598 W618MM WHI * \(qtyOfShelf)")
        print("50168 SHELF SUPPORT F SHELF PERFORATED METAL F SHELVING SYSTEM L584MM GALV * \(qtyOfShelf * 2 - sixtySection * 2)")
        print("50187 SHELF MESH F SHELVING SYSTEM D898 W618MM WHI * \(qtyOfShelf)")
        print("50184 SHELF SUPPORT F SHELVING SYSTEM L884MM WHI \(qtyOfShelf * 2 - nintySection * 2)")
        
        switch height {
        case 854:
            print("50216 Left side unit f shelving system D600 H854MM whi * \(sixtySection)")
            print("50217 Middle unit f shelving system D600 H854MM whi * \(sixtySection)")
            print("50218 Right side unit f shelving system D600 H854MM whi * \(sixtySection)")
            print("")
            print("50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            
        case 1340:
            print("50213 Left side unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("50214 Middle unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("50215 Right side unit f shelving system D600 H1304MM whi * \(sixtySection)")
            print("")
            print("50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            
        case 2480:
            print("50210 Left side unit f shelving system D600 H2480 whi * 1")
            print("50211 Middle unit f shelving system D600 H2480 whi * \(sixtySection + nintySection)")
            print("50212 Right side unit f shelving system D600 H2480 whi * 1")
            print("")
            print("50183 Crossbeam f shelving system L860mm whi * \(nintySection * 3)")
            print("50166 Crossbeam f shelving system L560MM whi * \(sixtySection * 3)")
            print("")
            print("50190 Ceiling support 680MM f shelving system whi * 2")
            print("50188 Ceiling support clamp f shelving system whi * 2")
            
        default:
            break
        }
    }
}



// 確認是否貨架是連在一起的
var isConnected: Bool  = false
// 確認是否貨架是Single side還Double side的
var isDoubleSide: Bool = false
var nintySections: Int = 3
var sixtySections: Int = 1
var depth: Int = 20

// MARK: -
public func calculationBracketsAndShelfs () {
    
    // 只有W600 sections，並沒有連結
    if nintySections.isMultiple(of: 0) && isConnected == false {
    // 如果不是Double side
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySections * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 4)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySections * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 4)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySections * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 4)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySections * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 4)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySections * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 4)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySections)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 2)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySections)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 2)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySections)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 2)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySections)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 2)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySections)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 2)")
            default:
                break
            }
        }
        
    // 只有W600 sections，並且連結在一起
    } else if nintySections.isMultiple(of: 0) && isConnected == true {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySections * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 6)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySections * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 6)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySections * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 6)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySections * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 6)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySections * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 6)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21451 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D200 WHI * \(sixtySections)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 3)")
            case 30:
                print("21452 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D300 WHI * \(sixtySections)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 3)")
            case 40:
                print("21453 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D400 WHI * \(sixtySections)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 3)")
            case 60:
                print("21454 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D600 WHI * \(sixtySections)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 3)")
            case 80:
                print("21455 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W600 D800 WHI * \(sixtySections)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(sixtySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(sixtySections * 3)")
            default:
                break
            }
        }
        
    // 只有W900的時候，並沒有連結
    } else if sixtySections.isMultiple(of: 0) && isConnected == false {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySections)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySections)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySections)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySections)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySections)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            default:
                break
            }
        } else {
            print("Single side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySections * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 4)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySections * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 4)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySections * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 4)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySections * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 4)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySections * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 4)")
            default:
                break
            }
        }
        
    // 只有W900 sections，並且連結在一起
    } else if sixtySections.isMultiple(of: 0)  && isConnected == true {
        if isDoubleSide {
            print("Double side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySections * 2)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 6)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySections * 2)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 6)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySections * 2)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 6)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySections * 2)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 6)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySections * 2)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySections * 4)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 6)")
            default:
                break
            }
        } else {
            print("Single Side")
            switch depth {
            case 20:
                print("21486 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D200 WHI * \(nintySections)")
                print("38202 BRACKET 2-TAB D200MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 30:
                print("21487 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D300 WHI * \(nintySections)")
                print("38203 BRACKET 2-TAB D300MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 40:
                print("21488 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D400 WHI * \(nintySections)")
                print("38207 BRACKET 3-TAB D400MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 60:
                print("21489 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D600 WHI * \(nintySections)")
                print("38208 BRACKET 3-TAB D600MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            case 80:
                print("21490 SHELF WIRE FOR LOCKING PIN LOW/MEDIUM LEDGE W900 D800 WHI * \(nintySections)")
                print("38209 BRACKET 3-TAB D800MM WHI * \(nintySections * 2)")
                print("10600 LOCKING PIN 6X25MM GALV * \(nintySections * 2)")
            default:
                break
            }
        }
    
    } else if nintySections > 0 && sixtySections > 0 && isConnected == false {
        
        
    } else if nintySections > 0 && sixtySections > 0 && isConnected == true {
        
        
    } else {
        
    }
}

// MARK: - Bins:
// Function for calculating standard bins
public func calculateStandardBins(qtyOfBin_forty_By_Sixty: Int, qtyOfBinSixty_By_Eighty: Int) {
    // Create a mutable string to store all the output
    var outputText = ""
    
    if qtyOfBin_forty_By_Sixty > 0 && qtyOfBinSixty_By_Eighty > 0 {
        outputText += "Bin數量大於1\n"
        outputText += "12483 CORNER POST F BIN H850MM WHI * \(qtyOfBin_forty_By_Sixty * 4 + qtyOfBinSixty_By_Eighty * 4)\n"
        outputText += "17740 SIDE F BIN L400 H700MM WHI * \(qtyOfBin_forty_By_Sixty * 2)\n"
        outputText += "17739 SIDE F BIN L60 H700MM WHI * \(qtyOfBin_forty_By_Sixty * 2 + qtyOfBinSixty_By_Eighty * 2)\n"
        outputText += "17743 SIDE F BIN L800 H700MM WHI * \(qtyOfBinSixty_By_Eighty * 2)\n"
        
    } else if qtyOfBin_forty_By_Sixty > 0 && qtyOfBinSixty_By_Eighty == 0 {
        outputText += "40 * 60的Bin 大於 1\n"
        outputText += "12483 CORNER POST F BIN H850MM WHI * \(qtyOfBin_forty_By_Sixty * 4)\n"
        outputText += "17740 SIDE F BIN L400 H700MM WHI * \(qtyOfBin_forty_By_Sixty * 2)\n"
        outputText += "17739 SIDE F BIN L600 H700MM WHI * \(qtyOfBin_forty_By_Sixty * 2)\n"
        
    } else if qtyOfBin_forty_By_Sixty == 0 && qtyOfBinSixty_By_Eighty > 0 {
        outputText += "60 * 80的Bin 大於 1\n"
        outputText += "12483 CORNER POST F BIN H850MM WHI * \(qtyOfBinSixty_By_Eighty * 4)\n"
        outputText += "17739 SIDE F BIN L600 H700MM WHI * \(qtyOfBinSixty_By_Eighty * 2)\n"
        outputText += "17743 SIDE F BIN L800 H700MM WHI * \(qtyOfBinSixty_By_Eighty * 2)\n"
    }
}

// Function for calculating pallet bins
public func calculatePalletBins(qtyOfPalletBin_sixty_By_Eighty: Int, qtyOfPalletBin_Eighty_By_OneHundredTwenty: Int) {
    if qtyOfPalletBin_sixty_By_Eighty > 0 && qtyOfPalletBin_Eighty_By_OneHundredTwenty > 0 {
        print("12482 BIN F HALF PALLET L600 W800 H760MM WHI \(qtyOfPalletBin_sixty_By_Eighty)")
        print("12484 BIN F PALLET L1200 W800 H760MMWHI \(qtyOfPalletBin_Eighty_By_OneHundredTwenty)")
    } else if qtyOfPalletBin_sixty_By_Eighty > 0 && qtyOfPalletBin_Eighty_By_OneHundredTwenty == 0 {
        print("12482 BIN F HALF PALLET L600 W800 H760MM WHI \(qtyOfPalletBin_sixty_By_Eighty)")
    } else if qtyOfPalletBin_sixty_By_Eighty == 0 && qtyOfPalletBin_Eighty_By_OneHundredTwenty > 0 {
        print("12484 BIN F PALLET L1200 W800 H760MMWHI \(qtyOfPalletBin_Eighty_By_OneHundredTwenty)")
    }
}
