//
//  SettingNotiController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit

class SettingNotiController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let arr = ["알림설정","이메일","SMS(문자)"];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "알림설정"
        
        //셀 테두리지우기
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //스크롤 enable
//        tableView.isScrollEnabled = false
        tableView.allowsSelection = false
    }
    
}

extension SettingNotiController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text="\(indexPath.row)"
        cell.textLabel?.text = arr[indexPath.row]
//        cell.cellImageView?.image = UIImage(named: emoji[indexPath.row])
//        cell.imageView?.image = UIImage(named: "save")
        
//        let customCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
//        customCell.imageviewCustom.image = UIImage(systemName: emoji[indexPath.row])
//        customCell.labelCustom.text = arr[indexPath.row]
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            //클릭한 셀의 이벤트 처리
//            tableView.deselectRow(at: indexPath, animated: false)
//
//            print("Click Cell Number: " + String(indexPath.row))
//
//    }
    
}
