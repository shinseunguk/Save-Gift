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
    @IBOutlet weak var uiView: UIView!
    
    let nowBrightness : CGFloat = UIScreen.main.brightness;
    
    var url : URL? = nil
    
    var uiImage : UIImage? = nil
    
    let dismissBtn = UIButton()
    let uiImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("\(LOG_TAG) viewDidLoad")
        Init()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIScreen.main.brightness = 1.0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIScreen.main.brightness = nowBrightness
    }
    
    func Init(){
        dismissBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissBtn.contentVerticalAlignment = .fill
        dismissBtn.contentHorizontalAlignment = .fill
        dismissBtn.tintColor = .systemBlue
//        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.uiView.addSubview(dismissBtn)
        
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dismissBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        dismissBtn.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 20).isActive = true
        dismissBtn.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 25).isActive = true
        
        uiImageView.image = uiImage
        uiImageView.contentMode = .scaleAspectFit
        self.uiView.addSubview(uiImageView)
        uiImageView.translatesAutoresizingMaskIntoConstraints = false
        uiImageView.topAnchor.constraint(equalTo: dismissBtn.bottomAnchor, constant: 10).isActive = true
        uiImageView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 0).isActive = true
        uiImageView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: 0).isActive = true
        uiImageView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 0).isActive = true
    }
    
    @objc func backAction() {
        print("backAction")
        dismiss(animated: true, completion: nil)
    }
}
