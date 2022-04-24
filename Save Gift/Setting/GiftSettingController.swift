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
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var lockImageView: UIImageView!
    var arr = ["로그아웃", "내정보", "개발자", "알림설정", "앱버전", "기프티콘 사용법", "회원탈퇴", "테스트화면"]
    
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        //네비게이션바 뒤로가기 삭제
        self.navigationItem.hidesBackButton = true
        
        if(UserDefaults.standard.string(forKey: "ID") != nil){ // 로그인 상태
            arr[0] = "로그아웃"
            loginBtn.isHidden = false
            loginLabel.isHidden = false
            lockImageView.isHidden = false
            self.loginLabel.text = UserDefaults.standard.string(forKey: "ID")!
        }else{ // 비로그인
            arr[0] = "로그인"
            loginBtn.isHidden = true
            loginLabel.isHidden = true
            lockImageView.isHidden = true
//            self.loginLabel.text = "로그인"
        }
        
    }
    
}

extension GiftSettingController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if indexPath.row == 0{
            cell.textLabel?.textColor = .red
        }
        cell.textLabel?.text = arr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //클릭한 셀의 이벤트 처리
            tableView.deselectRow(at: indexPath, animated: false)
            
            print("Click Cell Number: " + String(indexPath.row))
        
        if indexPath.row == 0{ //회원탈퇴
            if(UserDefaults.standard.string(forKey: "ID") != nil){
                UserDefaults.standard.removeObject(forKey: "ID")
                
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                        self.navigationController?.pushViewController(pushVC!, animated: true)
            }else{
                guard let pushVC = self.storyboard?.instantiateViewController(identifier: "viewVC") as? ViewController else{
                    return
                }
                
    //            pushVC.pushYn = push
    //            pushVC.emailYn = email
    //            pushVC.smsYn = sms
                        self.navigationController?.pushViewController(pushVC, animated: true)
                
                let backBarButtonItem = UIBarButtonItem(title: "설정", style: .plain, target: self, action: nil)
                self.navigationItem.backBarButtonItem = backBarButtonItem
            }
        }else if indexPath.row == 1{ //내정보
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingMyInfoVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }else{// 로그인 X
                needLoginService()
            }
        }else if indexPath.row == 2 { //개발자
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingDeveloperVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }else if indexPath.row == 3 { //알림설정
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingNotiControllerVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
        }else if indexPath.row == 4 { //앱버전
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingAppVersionVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }else if indexPath.row == 5 { //기프티콘 사용법
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingHowToUseVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }else if indexPath.row == 6 { //회원탈퇴
            if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
                let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingSecessionVC")
                self.navigationController?.pushViewController(pushVC!, animated: true)
            }else{// 로그인 X
                needLoginService()
            }
        }else if indexPath.row == 7 { //테스트화면
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "TestVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    func needLoginService(){
        let alert = UIAlertController(title: "로그인", message: "로그인이 필요한 서비스입니다. \n 로그인 화면으로 이동하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .destructive) { action in

        })
        alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
            self.navigationController?.pushViewController(pushVC!, animated: true)

            let backBarButtonItem = UIBarButtonItem(title: "휴대폰 인증", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
        })
        self.present(alert, animated: true, completion: nil)
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
