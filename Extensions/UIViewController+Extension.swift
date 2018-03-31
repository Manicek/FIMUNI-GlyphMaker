//
//  UIViewController+Extension.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 30/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showBasicAlert(message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("ok", comment: "|||OK"), style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
