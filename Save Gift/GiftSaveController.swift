//
//  GiftHowToUse.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 사용법ㅋ

import Foundation
import UIKit

class GiftSaveController : UIViewController{
    
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!

    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSaveController")
        
    }
}
