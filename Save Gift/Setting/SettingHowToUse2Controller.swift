//
//  SettingHowToUse2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/06/27.
//

import Foundation
import UIKit

class SettingHowToUse2Controller : UIViewController {
    
    var aTitle : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "\(aTitle!)"
        
    }
}
