//
//  BaseViewController.swift
//  TestTask
//
//  Created by Sourabh Jaiswal on 30/09/21.
//  Copyright © 2021 Saurabh Jaiswal. All rights reserved.
//

import UIKit
class BaseViewController: UIViewController {
    
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40.0, height: 40.0))

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.barTintColor = UIColor.black
       navigationController?.navigationBar.titleTextAttributes = [
       NSAttributedString.Key.foregroundColor: UIColor.white
       ]
       navigationController?.navigationBar.isTranslucent = false

       
       backButton.setImage(UIImage(named: "popBack_button"), for: .normal)
       backButton.setTitle("", for: .normal)
       backButton.contentHorizontalAlignment = .left
       backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
       backButton.addTarget(self, action: #selector(popBack), for: .touchUpInside)
       let backButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backButtonItem
        
        let rightBarButtonItem = UIBarButtonItem.init(image: UIImage(named: "cart"), style: .done, target: self, action: #selector(addCart))

        //navigationItem.rightBarButtonItem = rightBarButtonItem

    }
    
    @objc func popBack()
    {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func addCart()
    {
        
    }
    
    var hideNavigationBar = false {
            
           didSet {
               self.navigationController?.setNavigationBarHidden(hideNavigationBar, animated: false)
           }
       }
    
    
}
