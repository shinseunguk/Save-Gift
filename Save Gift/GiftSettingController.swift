//
//  GiftSetting.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  설정임 2022 01 11 22 01s//dd.

import Foundation
import UIKit

class GiftSettingController : UIViewController{
    
//    @IBOutlet weak var cell: UITableViewCell!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginBtn: UIButton!
    let arr = ["내정보", "개발자", "알림설정", "앱버전", "기프티콘 사용법", "회원탈퇴"]
    let emoji = ["barcode", "gift", "square.and.arrow.up", "crown", "scroll", "gear"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftSettingController")
        
        
        //셀 테두리지우기
//        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //스크롤 enable
        tableView.isScrollEnabled = false
        
        //cell 여백 삭제
        tableView.contentInset = .zero
        tableView.contentInsetAdjustmentBehavior = .never
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
        
//        let backBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
        self.navigationItem.backBarButtonItem?.title = "설정"

    
        //notworking
//        let backBarButtonItem = UIBarButtonItem(title: "설정2", style: .plain, target: self, action: nil)
//        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
    }
    
}

extension GiftSettingController: UITableViewDelegate, UITableViewDataSource{
    
    //for문 느낌
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text="\(indexPath.row)"
        cell.textLabel?.text = arr[indexPath.row]
//        cell.cellImageView?.image = UIImage(named: emoji[indexPath.row])
        
//        let customCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
//        customCell.imageviewCustom.image = UIImage(systemName: emoji[indexPath.row])
//        customCell.labelCustom.text = arr[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //클릭한 셀의 이벤트 처리
            tableView.deselectRow(at: indexPath, animated: false)
            
            print("Click Cell Number: " + String(indexPath.row))
        
        if indexPath.row == 0{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "infoVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
        } else if indexPath.row == 1{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "giftPresentPush")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        } else if indexPath.row == 2{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "giftSharePush")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        } else if indexPath.row == 3{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "giftRankPush")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        } else if indexPath.row == 4{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "giftHowToUsePush")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        } else if indexPath.row == 5{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "giftSettingPush")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
            
    }
    
    //cell 여백 삭제
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        UIView()
    }

    //cell 여백 삭제
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
}
