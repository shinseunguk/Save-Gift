//
//  FindidController.swift
//  Save Gift
//  Created by ukBook on 2021/12/18.
//

import Foundation
import UIKit
import JSPhoneFormat

class FindidController : UIViewController {
    let LOG_TAG : String = "FindidController"
    let helper = Helper()
    let localUrl = "".getLocalURL()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var cellPhoneTextField: UITextField!

    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var description1: UILabel!
    
    var nextBool : Bool = false
    
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")   //구분자로 사용하고싶은 캐릭터를 넣어주시면 됩니다.
    let border1 = CALayer()
    let border2 = CALayer()
    
    var minute : Int = 0
    var second : Int = 0
    var dic : Dictionary<String, Any> = [:]
    var checkDic: Dictionary<String, Any> = [:]
    var topLabel: UILabel = {

        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.textAlignment = .center
        topLabel.font = UIFont.systemFont(ofSize: 12)
        topLabel.textColor = .lightGray
        topLabel.backgroundColor = .white
        topLabel.numberOfLines = 1
        return topLabel

    }()
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        self.cellPhoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // cellPhoneTextField
        cellPhoneTextField.tag = 0
        cellPhoneTextField.keyboardType = .phonePad

        cellPhoneTextField.addLeftPadding()
//        cellPhoneTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: cellPhoneTextField.frame.size.height-1, width: cellPhoneTextField.frame.width, height: 1)
        border1.backgroundColor = UIColor.lightGray.cgColor
        cellPhoneTextField.layer.addSublayer((border1))
        cellPhoneTextField.textAlignment = .left
        cellPhoneTextField.textColor = UIColor.black
        cellPhoneTextField.attributedPlaceholder = NSAttributedString(string: "휴대전화 번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        //gray변경
        cellPhoneTextField.tintColor = UIColor.systemBlue
        //
        
        // authNumberTextField
        self.nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.tag = 1
        
        
        nameTextField.addLeftPadding()
//        nameTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: nameTextField.frame.size.height-1, width: nameTextField.frame.width, height: 0)
        border1.backgroundColor = UIColor.lightGray.cgColor
        nameTextField.layer.addSublayer((border1))
        nameTextField.textAlignment = .left
        nameTextField.textColor = UIColor.black
        nameTextField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        nextBtn.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellPhoneTextField.text = ""
        
        nameTextField.text = ""
        
        nextBtn.backgroundColor = .systemGray2
        nextBtn.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        topLabel.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavTitle()
        labelSetColor()
    }
    
    func setNavTitle(){
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "아이디 찾기"
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0{
            checkMaxLength(textField: cellPhoneTextField, maxLength: 13)
            guard let text = cellPhoneTextField.text else { return }
            cellPhoneTextField.text = phoneFormat.addCharacter(at: text)
        }else if textField.tag == 1{
            checkMaxLength(textField: nameTextField, maxLength: 10)
        }
        if nameTextField.text?.count != 0 && cellPhoneTextField.text?.count == 13{
            nextBtn.backgroundColor = .systemBlue
            nextBtn.isEnabled = true
        }else {
            nextBtn.backgroundColor = .systemGray2
            nextBtn.isEnabled = false
        }
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (cellPhoneTextField.text?.count ?? 0 > maxLength) {
                cellPhoneTextField.deleteBackward()
            }
        }else if textField.tag == 1 {
            if (nameTextField.text?.count ?? 0 > maxLength) {
                nameTextField.deleteBackward()
            }
        }
        
    }
    
    func labelSetColor(){
//         NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr1 = NSMutableAttributedString(string: description1.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (description1.text! as NSString).range(of: "휴대폰 번호"))
        // 설정이 적용된 text를 label의 attributedText에 저장
        description1.attributedText = attributedStr1
        
    }
    
    @IBAction func nextAction(_ sender: Any) {
        print("\(#function)")
        // DB SELECT 후 다음화면으로
        dic["name"] = nameTextField.text
        dic["phone_number"] = cellPhoneTextField.text
        checkNamePhone(requestUrl: "/check/namephone", param: dic)
    }
    
    
    func checkNamePhone(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("checkSms param.... ", param)
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

//                    print("GiftDetail responseString \n", responseString!)
                    var responseStringA = responseString as! String
                    DispatchQueue.main.async {
                        if responseStringA == "true"{
                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "Register2") as? Register2Controller else{
                                return
                            }
                            
                            pushVC.nameFromFindId = self.nameTextField.text!
                            pushVC.phoneNumberFromFindId = self.cellPhoneTextField.text!
                            self.navigationController?.pushViewController(pushVC, animated: true)
                        }else {
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "가입된 정보중 이름과 휴대폰 번호가 존재하지 않거나 일치하지 않습니다", completeTitle: "확인", nil)
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
}
