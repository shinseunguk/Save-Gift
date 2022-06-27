//
//  SettingHowToUseController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit
import KakaoSDKCommon

class SettingHowToUseController : UIViewController {
    
    let faqTableView = UITableView()
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    
    
    var faqArr : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 사용법"
        
        faqArrSetUP() // 배열 append 함수
        tableViewSetUp()
    }
    
    func faqArrSetUP(){
        faqArr.append("기프티콘 수첩이란?")
        faqArr.append("기능 소개")
        faqArr.append("기프티콘 저장은 어떻게 하나요?")
        faqArr.append("기프티콘 선물은 어떻게 하나요?")
        faqArr.append("기프티콘 유효기간 알림을 받고싶어요")
        faqArr.append("사용하지 않은 기프티콘이 앱에서 사라졌어요")
        faqArr.append("선물함에 있던 기프티콘이 앱에서 사라졌어요")
        faqArr.append("친구추가에서 친구를 찾을수 없어요")
        faqArr.append("앱 업데이트가 필요하다고 나와요")
        faqArr.append("내정보 변경을 하고싶어요")
        faqArr.append("회원 탈퇴 하고싶어요")
    }
    
    func tableViewSetUp(){
        faqTableView.isScrollEnabled = false
        faqTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        faqTableView.dataSource = self
        faqTableView.delegate = self
        self.scrollView.addSubview(faqTableView)
        
        faqTableView.register(UINib(nibName: "SettingHowToUseCell", bundle: nil), forCellReuseIdentifier: "SettingHowToUseCell")
        
        faqTableView.translatesAutoresizingMaskIntoConstraints = false
        faqTableView.topAnchor.constraint(equalTo: faqLabel.bottomAnchor, constant: 40).isActive = true
        faqTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
        faqTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -20).isActive = true
        
        faqTableView.heightAnchor.constraint(equalToConstant: 900).isActive = true
    }
    
}

extension SettingHowToUseController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80
   }
    
    // Set the spacing between sections
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        print("heightForHeaderInSection!!")
//        return 30
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHowToUseCell", for: indexPath) as! SettingHowToUseCell
        cell.leftLabel.numberOfLines = 3
        cell.leftLabel?.text = faqArr[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(faqArr[indexPath.row])
        
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingHowToUse2Controller") as? SettingHowToUse2Controller
        
        pushVC?.aTitle = faqArr[indexPath.row]
        self.navigationController?.pushViewController(pushVC!, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        switch indexPath.row {
        case 0:
            print("0")
            break
        case 1:
            print("1")
            break
        default:
            print("default")
        }
    }
    
}
