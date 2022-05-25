//
//  GiftFriend2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/05/24.
//

import Foundation
import UIKit

class GiftFriend2Controller : UIViewController {
    let LOG_TAG : String = "GiftFriend2Controller"
    
    var uiViewHeightConstraint : NSLayoutConstraint?
    var topTableViewHeightConstraint : NSLayoutConstraint?
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!

    let dismissBtn = UIButton()
    let topLabel = UILabel()
    let topTableView = UITableView()
    let bottomLabel = UILabel()
    let bottomTableView = UITableView()
    
//    var arr1 : [String] = ["요청된 친구가 없습니다."]
//    var arr2 : [String] = ["친구를 추가해 기프티콘을 선물, 공유 해보세요."]
//    var status : [String] = []
    var arr1 : [String] = ["aa@naver.com", "bb@naver.com", "cc@naver.com"] // TEST
    var arr2 : [String] = ["krdut1@gmail.com"] // TEST
    var status : [String] = ["W", "P", "W"] // TEST

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GiftFriend2Controller \(#function)")
        
        dismissBtnSetup()
//        dismissBtnHidden() // X Btn 숨기기
        
        topLabelSetUp() // [친구 요청]
        topTableViewSetUp() // 친구요청 테이블뷰
        bottomLabelSetUp() // [친구]
        bottomTableViewSetUp() // 친구 테이블뷰
        uiViewSetUp()
    }
    
    func dismissBtnSetup(){
        dismissBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissBtn.contentVerticalAlignment = .fill
        dismissBtn.contentHorizontalAlignment = .fill
        dismissBtn.tintColor = .systemBlue
//        dismissBtn.backgroundColor = .black
        dismissBtn.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        self.scrollView.addSubview(dismissBtn)
        
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dismissBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        dismissBtn.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 10).isActive = true
        dismissBtn.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func dismissBtnHidden(){
        dismissBtn.isHidden = true
    }
    
    func topLabelSetUp(){
//        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        topLabel.textAlignment = .center
        topLabel.text = "[친구 요청]"
        topLabel.textColor = .systemGray2
//        topLabel.backgroundColor = .systemIndigo
        self.scrollView.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        
        topLabel.topAnchor.constraint(equalTo: dismissBtn.bottomAnchor, constant: 10).isActive = true
        topLabel.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func topTableViewSetUp(){
        topTableView.isScrollEnabled = false
        
        topTableView.backgroundColor = .systemIndigo
        topTableView.dataSource = self
        topTableView.delegate = self
        self.scrollView.addSubview(topTableView)
        topTableView.register(UINib(nibName: "GetFriendTableViewCell", bundle: nil), forCellReuseIdentifier: "GetFriendTableViewCell")

        topTableView.backgroundColor = .black
        topTableView.translatesAutoresizingMaskIntoConstraints = false
        topTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10).isActive = true
        topTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 10).isActive = true
        topTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -10).isActive = true
//        topTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr1.count * 50)).isActive = true
        topTableViewHeightConstraint = topTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr1.count * 50))
        topTableViewHeightConstraint?.isActive = true
    }
    
    func bottomLabelSetUp(){
        bottomLabel.textAlignment = .center
        bottomLabel.text = "[친구]"
        bottomLabel.textColor = .systemGray2
        self.scrollView.addSubview(bottomLabel)
        
        bottomLabel.translatesAutoresizingMaskIntoConstraints = false
        
        bottomLabel.topAnchor.constraint(equalTo: topTableView.bottomAnchor, constant: 30).isActive = true
        bottomLabel.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
    }
    
    func bottomTableViewSetUp(){
        bottomTableView.isScrollEnabled = false
        
        bottomTableView.backgroundColor = .systemIndigo
        bottomTableView.dataSource = self
        bottomTableView.delegate = self
        self.scrollView.addSubview(bottomTableView)
        bottomTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        bottomTableView.translatesAutoresizingMaskIntoConstraints = false
        bottomTableView.topAnchor.constraint(equalTo: bottomLabel.bottomAnchor, constant: 10).isActive = true
        bottomTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 10).isActive = true
        bottomTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -10).isActive = true
        bottomTableView.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 0).isActive = true
//        bottomTableView.heightAnchor.constraint(equalToConstant: CGFloat(arr2.count * 50)).isActive = true
    }
    
    func uiViewSetUp(){
        uiView.backgroundColor = .systemGreen
        uiView.frame.size.height = 300
        
        let totalHeight = CGFloat((arr1.count * 50 + arr2.count * 50) + 190)
        
        print("totalHeight -----> ", totalHeight)
        uiView.translatesAutoresizingMaskIntoConstraints = false
//        uiView.heightAnchor.constraint(equalToConstant: totalHeight).isActive = true
        uiViewHeightConstraint = uiView.heightAnchor.constraint(equalToConstant: totalHeight)
        uiViewHeightConstraint?.isActive = true
    }
    
    
    @objc func dismissAction(){
        print("dismissAction")
        
        // constraint change
        self.uiViewHeightConstraint?.constant = 800
        self.topTableViewHeightConstraint?.constant = 300
//        self.view.layoutIfNeeded()
    }
    
    func normalAlert(title : String, message : String, email : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if message == "친구가 수락 대기중입니다. 친구요청을 취소 하시겠습니까?" {
            alert.addAction(UIAlertAction(title: "아니오", style: .cancel) { action in
                print("아니오")
            })
            alert.addAction(UIAlertAction(title: "요청취소", style: .default) { action in
                print("요청취소")
//                self.requestDeleteFriendWait(requestUrl: "/deleteFriendWait", friend: email!, index: "me")
            })
        }else {
            alert.addAction(UIAlertAction(title: "확인", style: .default) { action in
                print("확인")
            })
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func alert(email : String){
        let alert = UIAlertController(title: "알림", message: "\(email)님이 친구를 요청했습니다. 수락 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "거절", style: .cancel) { action in
            print("거절")
            self.reAlert(email: email)
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "수락", style: .destructive) { action in
            print("수락")
//            self.requestAddFriend(requestUrl: "/addFriend", friend : email)
            //DB delete후
            //DB insert
        })
        // 기능추가 예정
//        alert.addAction(UIAlertAction(title: "이 사용자 차단", style: .default) { action in
//            print("이 사용자 차단")
//        })
        self.present(alert, animated: true, completion: nil)
//        actionButton.isHidden = false
        
    }
    
    func reAlert(email : String){
        let alert = UIAlertController(title: "알림", message: "정말로 \(email)님을 거절 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            print("취소")
            //DB delete
        })
        alert.addAction(UIAlertAction(title: "거절", style: .default) { action in
            print("거절")
//            self.requestDeleteFriendWait(requestUrl: "/deleteFriendWait", friend: email, index: nil)
            //DB delete후
            //DB insert
        })
        // 기능추가 예정
//        alert.addAction(UIAlertAction(title: "이 사용자 차단", style: .default) { action in
//            print("이 사용자 차단")
//        })
        self.present(alert, animated: true, completion: nil)
//        actionButton.isHidden = false
        
    }
    
    func normalActionSheet(title : String?, message : String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "선물하기(기프티콘)", style: .default) { action in
                print("선물하기")
            })
            alert.addAction(UIAlertAction(title: "친구삭제", style: .destructive) { action in
                print("친구삭제")
//                self.requestDeleteFriend(requestUrl: "/delete/friend", friend: message!)
            })
            alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
                print("취소")
            })
            
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension GiftFriend2Controller : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == topTableView {
//            print("arr1.count ", arr1.count)
            return arr1.count
        }
        if tableView == bottomTableView {
//            print("arr2.count ", arr2.count)
            return arr2.count
        }

        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == topTableView {
            let customCell = self.topTableView.dequeueReusableCell(withIdentifier: "GetFriendTableViewCell", for: indexPath) as! GetFriendTableViewCell
//            print("arr1[indexPath.row] ", arr1[indexPath.row])
                if arr1[0] == "요청된 친구가 없습니다."{
                        print("status[0]")
                        customCell.emailLabel?.textColor = UIColor.systemBlue
                        customCell.statusLabel.text = ""
                        customCell.emailLabel.text = "요청된 친구가 없습니다."
                        customCell.selectionStyle = .none
                } else {
                    customCell.emailLabel?.textColor = UIColor.black
                    customCell.selectionStyle = .default
                }
            
            customCell.emailLabel.text = arr1[indexPath.row]
            if status.count != 0 {
                if status[indexPath.row] == "W"{
                    customCell.statusLabel.textColor = UIColor.systemIndigo
                    customCell.statusLabel.text = "친구가 수락대기중"
                } else if status[indexPath.row] == "P"{
                    customCell.statusLabel.textColor = UIColor.systemRed
                    customCell.statusLabel.text = "거절 / 수락"
                }
            }
            
            return customCell
        } else if tableView == bottomTableView {
            print("arr2[indexPath.row] ", arr2[indexPath.row])
            let cell = self.bottomTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
                if arr2[0] == "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                    cell.textLabel?.textColor = UIColor.systemBlue
                    cell.selectionStyle = .none
                } else{
                    cell.textLabel?.textColor = UIColor.black
                    cell.selectionStyle = .default
                }
            
            //dev-dream-world.tistory.com/31 tableview
            cell.textLabel?.text = arr2[indexPath.row]
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        
        // P ->  거절 / 수락       W -> 친구가 수락 대기중
        if tableView == topTableView {
//            print("arr1[indexPath.row] ", arr1[indexPath.row])
//            print("status[indexPath.row] ", status[indexPath.row])
            if arr1[indexPath.row] != "요청된 친구가 없습니다." {
                if status[indexPath.row] == "W" {
                    self.normalAlert(title: "알림", message:  "친구가 수락 대기중입니다. 친구요청을 취소 하시겠습니까?", email: arr1[indexPath.row])
                } else{
                    self.alert(email: arr1[indexPath.row])
                }
            }
        }
        if tableView == bottomTableView {
            if arr2[indexPath.row] != "친구를 추가해 기프티콘을 선물, 공유 해보세요."{
                self.normalActionSheet(title: "기프티콘 저장소", message: arr2[indexPath.row])
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
