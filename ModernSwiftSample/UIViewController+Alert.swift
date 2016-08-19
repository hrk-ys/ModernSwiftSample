//
//  UIViewController+Alert.swift
//  ModernSwiftSample
//
//  Created by Hiroki Yoshifuji on 2016/08/18.
//  Copyright © 2016年 hiroki.yoshifuji. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showError(error: NSError) {
        
        let alert = UIAlertController(title: error.domain, message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        presentViewController(alert, animated: true, completion: nil)
    }
}
