//
//  GiftDetailController.swift
//  Save Gift
//
//  Created by mac on 2022/04/07.
//

import Foundation
import UIKit

class GiftDetailControoler : UIViewController{
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageExpandBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let categoryArr = ["바코드번호", "교환처", "상품명", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var contentArr =  ["1234567890", "호식이두마리치킨", "후라이드+양념치킨+500ml", "2021-06-17", "미사용", "2022-04-08", "ghdrlfehd@naver.com(홍길동)"]
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        setupLayout()
        
        tableView.allowsSelection = false
        
        tableView.register(UINib(nibName: "GiftDetailBarcodeTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailBarcodeTableViewCell")
        tableView.register(UINib(nibName: "GiftDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailTableViewCell")
    }
    
    func setupLayout(){
        imageExpandBtn.layer.cornerRadius = 5
    }
    
    @IBAction func imageExpandAction(_ sender: Any) {
        print("imageExpandAction")
    }
    
}

extension GiftDetailControoler : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GiftDetailTableViewCell") as! GiftDetailTableViewCell
        
        cell.copyBtn.layer.cornerRadius = 5
        cell.copyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 3)
        cell.copyBtn.titleLabel?.font = .systemFont(ofSize: 3)
        
//        btn.titleLabel?.font = .systemFont(ofSize: 12)
    
        // 바코드번호 클립보드저장 버튼
        if indexPath.row != 0 {
            cell.copyBtn.isHidden = true
        }
        
        //미사용, 사용 set Color
        if indexPath.row == 4{
            print("contentArr[4] ", contentArr[4])
            if categoryArr[4] == "미사용"{
                print("미사용.... ")
                cell.secondLabel.textColor = UIColor.green
            }else if categoryArr[4] == "사용"{
                print("사용.... ")
                cell.secondLabel.textColor = UIColor.red
            }
        }else {
            print("contentArr2 ", contentArr[indexPath.row])
            cell.secondLabel.textColor = UIColor.black
        }
//        cell.secondLabel.textColor = UIColor.red
        
        cell.firstLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        cell.firstLabel.text = categoryArr[indexPath.row]
        cell.secondLabel.text = contentArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
  
}
