//
//  GiftHowToUse.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 사용법ㅋ

import Foundation
import UIKit
import JJFloatingActionButton


class GiftSaveController : UIViewController{
    
    @IBOutlet weak var tabBar: UITabBarItem!
    // MARK: EffectView가 들어갈 View
    @IBOutlet weak var viewMain: UIView!

    // MARK: Blur효과가 적용될 EffectView
    var viewBlurEffect:UIVisualEffectView!
    let actionButton = JJFloatingActionButton()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSaveController viewDidLoad")
        
//        actionButton.addItem(title: "바코드 저장하기", image: UIImage(systemName: "barcode")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//            print("item 1")
//        }
//
//        actionButton.addItem(title: "QR코드 저장하기", image: UIImage(systemName: "qrcode")?.withRenderingMode(.alwaysTemplate)) { item in
//          // do something
//            print("item 2")
//        }
//
////        actionButton.addItem(title: "item 3", image: nil) { item in
////          // do something
////        }
//
//        view.addSubview(actionButton)
//        actionButton.buttonColor = .systemBlue
//        actionButton.translatesAutoresizingMaskIntoConstraints = false
//        actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
//        actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}
