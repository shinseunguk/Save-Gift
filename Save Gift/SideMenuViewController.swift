//
//  SideMenuViewController.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/19.
//

import UIKit

class SideMenuViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cellImageView: UIImageView!
    
    let arr = ["기프티콘 저장", "기프티콘 선물하기", "내친구와 기프티콘 공유하기", "기프티콘 랭킹보기", "기프티콘 사용법", "설정"]
    let emoji = ["barcode", "gift", "square.and.arrow.up", "crown", "scroll", "gear"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.cornerRadius = self.imageView.frame.size.height / 2
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        // 뷰의 경계에 맞춰준다
        imageView.clipsToBounds = true
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.labelPressed))
        imageView.addGestureRecognizer(gestureRecognizer)

        
        //셀 테두리지우기
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //스크롤 enable
        tableView.isScrollEnabled = false
    }
    
    @objc func labelPressed(){
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
        self.navigationController?.pushViewController(pushVC!, animated: true)
     }


    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            navigationController?.setNavigationBarHidden(true, animated: animated)
            print("SideMenuViewController viewWillAppear()") //

        }

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        print("SideMenuViewController viewWillDisappear()")
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    @IBAction func sideMenuLoginAction(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
    
}

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text="\(indexPath.row)"
//        cell.textLabel?.text = arr[indexPath.row]
//        cell.cellImageView?.image = UIImage(named: emoji[indexPath.row])
//        cell.imageView?.image = UIImage(named: "save")
        
        let customCell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! CustomCell
        customCell.imageviewCustom.image = UIImage(systemName: emoji[indexPath.row])
        customCell.labelCustom.text = arr[indexPath.row]
        
        
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 70
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //클릭한 셀의 이벤트 처리
            tableView.deselectRow(at: indexPath, animated: false)
            
            print("Click Cell Number: " + String(indexPath.row))
        
        if indexPath.row == 0{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "main2Push")
            self.navigationController?.pushViewController(pushVC!, animated: true)
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
    
}


