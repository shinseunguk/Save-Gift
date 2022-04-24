//
//  TestController.swift
//  Save Gift
//
//  Created by ukBook on 2022/04/23.
//

import Foundation
import UIKit

class TestController : UIViewController{
    @IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func btnAction(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}
