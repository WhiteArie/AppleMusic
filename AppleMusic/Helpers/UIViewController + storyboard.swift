//
//  UIViewController + storyboard.swift
//  AppleMusic
//
//  Created by White on 10/19/22.
//

import Foundation
import UIKit


extension UIViewController{
    
    class func LoadFromStoryboard<T: UIViewController>() -> T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController() as? T{
            
            return viewController
            
        }else{
            fatalError("ERROR: no viewController in \(name) storyboard")
        }
        
    }
    
    
}
