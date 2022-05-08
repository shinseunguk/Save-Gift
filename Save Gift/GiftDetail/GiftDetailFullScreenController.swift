//
//  GiftDetailFullScreenController.swift
//  Save Gift
//
//  Created by ukBook on 2022/05/07.
//

import Foundation
import UIKit

class GiftDetailFullScreenController : UIViewController{
    let LOG_TAG : String = "GiftDetailFullScreenController"
    @IBOutlet weak var imageView: UIImageView!
    
    var url : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(LOG_TAG) viewDidLoad")
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIScreen.main.brightness = 1.0
    }
    
    func setUp(){
        print("\(LOG_TAG) url ==> ", url!)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: self.url!)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data!)
            }
        }
    }
    @IBAction func backAction(_ sender: Any) {
        print("backAction")
        dismiss(animated: true, completion: nil)
    }
}
