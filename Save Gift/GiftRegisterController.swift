//
//  GiftRegisterController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/16.
//

import Foundation
import UIKit


class GiftRegisterController : UIViewController{
    
    @IBOutlet weak var plusBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 등록 화면"
        
        plusBtn.layer.cornerRadius = 10;
//        plusBtn.layer.borderWidth = 2;
//        plusBtn.layer.borderColor = UIColor.systemBlue.cgColor
        
        
        //버튼 점선
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = plusBtn.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
                shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
                shapeLayer.fillColor = UIColor.clear.cgColor
                shapeLayer.strokeColor = UIColor.systemBlue.cgColor
                shapeLayer.lineWidth = 2
                shapeLayer.lineJoin = CAShapeLayerLineJoin.round
                shapeLayer.lineDashPattern = [6,3]
                shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
        
        plusBtn.layer.addSublayer(shapeLayer)
    }
    @IBAction func plusAction(_ sender: Any) {
        print("사진 추가 버튼")
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) {
            (action) in self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){
        print("openLibrary")
    }
    
    func openCamera(){
        print("openCamera")
    }
}
