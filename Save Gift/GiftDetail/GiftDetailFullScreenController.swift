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
    @IBOutlet weak var backBtn: UIButton!
    
    let nowBrightness : CGFloat = UIScreen.main.brightness;
    
    var url : URL? = nil
    
    var uiImage : UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(LOG_TAG) viewDidLoad")
        setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIScreen.main.brightness = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIScreen.main.brightness = nowBrightness
    }
    
    func setUp(){
        self.imageView.image = uiImage
        
        backBtn.layer.cornerRadius = 5
    }
    @IBAction func backAction(_ sender: Any) {
        print("backAction")
        dismiss(animated: true, completion: nil)
    }
}
