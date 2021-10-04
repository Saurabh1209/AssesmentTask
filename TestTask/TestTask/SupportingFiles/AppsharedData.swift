//
//  AppsharedData.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 30/09/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import Foundation
import UIKit

var appshared = AppsharedData.sharedInstance

class AppsharedData {
    
    
   static let sharedInstance = AppsharedData()
    
    func showAlertControllerWith(title : String, andMessage:String)  {
        let viewcontroller = self.getVisibleViewController(nil)
        let otherAlert = UIAlertController(title: title, message: andMessage, preferredStyle: UIAlertController.Style.alert)
        
        
        let dismiss = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        
        // relate actions to controllers
        otherAlert.addAction(dismiss)
        
        viewcontroller?.present(otherAlert, animated: true, completion: nil)
    }
    
    func getVisibleViewController(_ rootViewController: UIViewController?) -> UIViewController? {
        
        var rootVC = rootViewController
        if rootVC == nil {
            rootVC = UIApplication.shared.keyWindow?.rootViewController
        }
        
        if rootVC?.presentedViewController == nil {
            return rootVC
        }
        
        if let presented = rootVC?.presentedViewController {
            if presented.isKind(of: UINavigationController.self) {
                let navigationController = presented as! UINavigationController
                return navigationController.viewControllers.last!
            }
            
            if presented.isKind(of: UITabBarController.self) {
                let tabBarController = presented as! UITabBarController
                return tabBarController.selectedViewController!
            }
            
            return getVisibleViewController(presented)
        }
        return nil
    }
    
    func uniq<S : Sequence, T : Hashable>(source: S) -> [T] where S.Iterator.Element == T {
           var buffer = [T]()
           var added = Set<T>()
           for elem in source {
               if !added.contains(elem) {
                   buffer.append(elem)
                   added.insert(elem)
               }
           }
           return buffer
       }
    
    func addDifferentColorToText (fulltext:String, coloredtext:String, normalColor:UIColor, highlightedColor:UIColor) -> NSMutableAttributedString {
        let textRange = fulltext.nsRange(from: fulltext.range(of: coloredtext)!)
        let attributedText = NSMutableAttributedString(string: fulltext)
        attributedText.addAttributes([NSAttributedString.Key.underlineColor:UIColor.black,NSAttributedString.Key.foregroundColor:normalColor], range: NSMakeRange(0, fulltext.count))
        attributedText.addAttributes([NSAttributedString.Key.underlineColor:UIColor.black,NSAttributedString.Key.foregroundColor:highlightedColor], range: textRange)
        // Add other attributes if needed
        return attributedText
    }
    
    
}
