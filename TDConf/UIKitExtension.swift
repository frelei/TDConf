//
//  UIKitExtension.swift
//  TDConf
//
//  Created by Rodrigo Leite on 10/04/16.
//  Copyright © 2016 Rodrigo Leite. All rights reserved.
//

import Foundation
import UIKit

enum TITILLIUM : String{
    case REGULAR = "TitilliumWeb-Regular"
    case SEMI_BOLD = "TitilliumWeb-SemiBold"
    case LIGHT_ITALIC = "TitilliumWeb-LightItalic"
    case THIN = "TitilliumWeb-Thin"
    case THIN_ITALIC = "TitilliumWeb-ThinItalic"
    case LIGHT = "TitilliumWeb-Light"
    case ITALIC = "TitilliumWeb-Italic"
    case BLACK = "TitilliumWeb-Black"
    case BOLD = "TitilliumWeb-Bold"
    case BOLD_ITALIC = "TitilliumWeb-BoldItalic"
    case SEMI_BOLD_ITALIC = "TitilliumWeb-SemiBoldItalic"
}

extension NSDate
{
    
    func getHour() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Hour, fromDate: self);
        return components.hour
    }
    
    func getMinutes() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Minute, fromDate: self);
        return components.minute
    }
    
    func getYear() -> Int
    {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.Year, fromDate: self);
        return components.year
    }    
}


extension UIImage{
    
    class func loadImageFrom(URL: NSURL, completion:(image: UIImage) -> Void)
    {
        let queue = dispatch_queue_create("TDConf.image", DISPATCH_QUEUE_CONCURRENT)
        dispatch_async(queue)
        {
            let imageData = NSData(contentsOfURL: URL)
            let image = UIImage(data: imageData!)
            completion(image: image!)
        }
    }
}

extension UIColor{
    /**
        Convenience Initializer to create a UIColor. e.g: UIColor(red: 255, green: 165, blue: 0)
        
        - Param red: Int
        - Param green: Int
        - Param blue: Int
        - return UIColor
 
    */
    convenience init(red: Int, green: Int, blue: Int)
    {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
    /**
        Convinience initializer to crate a UIColor based on an hexdecimal value
        e.g: var color = UIColor(netHex:0xFFFFFF)
     
        - Param hex: Int
        - return UIColor
    */
    convenience init(hex:Int)
    {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    /** Custom Color */
    class func TDCRed() -> UIColor
    {
        return UIColor(hex: 0xDB413C)
    }
    
    class func TDCOrange() -> UIColor
    {
        return UIColor(hex: 0xEF6630)
    }
    
    class func TDCYellow() -> UIColor
    {
        return UIColor(hex: 0xF8B839)
    }
    
    class func TDCGreen() -> UIColor
    {
        return UIColor(hex: 0x439144)
    }
    
    class func TDCDarkGreen() -> UIColor
    {
        return UIColor(hex: 0x224433)
    }
    
    class func TDCBlue() -> UIColor
    {
        return UIColor(hex: 0x369CDB)
    }
    
    class func TDCDarkBlue() -> UIColor
    {
        return UIColor(hex: 0x0A5095)
    }
    
    class func TDCLightDark() -> UIColor
    {
        return UIColor(hex: 0x402B3A)
    }
    
}
