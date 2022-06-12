//
//  Findid2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/06/10.
//

import Foundation
import UIKit
class Findid2Controller : UIViewController{
    
    let LOG_TAG = "Findid2Controller"
    let localUrl = "".getLocalURL()
    let helper = Helper()
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var findIdArr : [String] = []
    var dictionaryFromFindId : Dictionary<String, Any> = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(#function)")
        //TEST
//        dictionaryFromFindId["name"] = "신욱승"
//        dictionaryFromFindId["phone_number"] = "010-8831-1502"
        //TEST
        
        setUpTopLabel()
        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        checkNamePhone(requestUrl: "/find/id", param: dictionaryFromFindId)
    }
    
    func setUpTopLabel(){
        topLabel.text = "\(String(describing: dictionaryFromFindId["name"]!))님의 아이디 찾기 결과입니다."
        
        let attributedStr1 = NSMutableAttributedString(string: topLabel.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.black, range: (topLabel.text! as NSString).range(of: "님의 아이디 찾기 결과입니다."))
        // 설정이 적용된 text를 label의 attributedText에 저장
        topLabel.attributedText = attributedStr1
    }
    
    override func viewDidLayoutSubviews() {
        leftBtn.layer.cornerRadius = 5
        rightBtn.layer.cornerRadius = 5
        tableView.layer.cornerRadius = 10
    }
    
    @IBAction func leftBtnAction(_ sender: Any) {
        // 원하는 화면으로 pop
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        print("\(#line) ", viewControllers)
        for aViewController in viewControllers {
            if aViewController is ViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
    @IBAction func rightBtnAction(_ sender: Any) {
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "FindpwController") as? FindpwController else{
            return
        }
        
        pushVC.nameFromFindId2 = dictionaryFromFindId["name"] as! String
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    func checkNamePhone(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("/find/id param.... ", param)
        let paramData = try! JSONSerialization.data(withJSONObject: param)
        // URL 객체 정의
                let url = URL(string: localUrl+requestUrl)

                // URLRequest 객체를 정의
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = paramData

                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                // URLSession 객체를 통해 전송, 응답값 처리
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
                        return
                    }

                var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("/check/namephone responseString \n", responseString!)
                    var responseStringA = responseString as! String
                    DispatchQueue.main.async {
                        if responseStringA != ""{
                            
//                            self.findIdArr.append("samdori96@nate.com")
//                            self.findIdArr.append("krdut1@gmail.com")
                            self.findIdArr = responseStringA.components(separatedBy: "&")
                            
                            self.tableView.dataSource = self
                            self.tableView.delegate = self
                        }else {
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "아이디 찾기 실패", completeTitle: "확인", nil)
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
}

extension Findid2Controller: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if findIdArr.count > 10 {
            tableView.isScrollEnabled = true
        }else {
            tableView.isScrollEnabled = false
        }
        
        return findIdArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = findIdArr[indexPath.row]
        cell.textLabel?.textColor = .systemBlue
        cell.textLabel?.textAlignment = .center
//        cell.backgroundColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        
        return cell
    }
    
}
