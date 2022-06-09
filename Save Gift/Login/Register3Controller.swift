//
//  Register3Controller.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/15.
//

import UIKit
import LocalAuthentication
import JSPhoneFormat

//extension UITextField {
//
//}

class Register3Controller: UIViewController, UITextFieldDelegate{
    let LOG_TAG : String = "Register3Controller"
    let helper : Helper =  Helper()
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordCheckInput: UITextField!
    @IBOutlet weak var telInput: UITextField!
    @IBOutlet weak var emailCheckText: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var registerEnable : Bool = false;
    let border1 = CALayer()
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")   //구분자로 사용하고싶은 캐릭터를 넣어주시면 됩니다.
    let localUrl = "".getLocalURL();
    
    var phoneNumber : String? = nil


    //넘어온 값
//    var pushYn : Bool?
    var emailYn : Bool?
    var smsYn : Bool?
    
    //넘어온 값 -> int 캐스팅
//    var push_yn : Int?
    var email_yn : Int?
    var sms_yn : Int?
    
    var name : String?
    var email : String?
    var password : String?
    var passwordCheck : String?
    var telNumber : String?
    var profile = [String:Any]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        
        emailCheckText!.text! = ""
        
        telInputSetUp()
        
        btnConfirm.isEnabled = false
        print("Register3Controller")
//        print("pushYN BOOL", pushYn!)
        print("emailYn BOOL", emailYn!)
        print("smsYn BOOL", smsYn!)
        
        // Bool -> Int 캐스팅
//        if pushYn! {
//            push_yn = 1
//        } else{
//            push_yn = 0
//        }
        
        if emailYn! {
            email_yn = 1
        } else{
            email_yn = 0
        }
        
        if smsYn! {
            sms_yn = 1
        } else{
            sms_yn = 0
        }
        
//        print("pushYN int", push_yn!)
        print("emailYn int", email_yn!)
        print("smsYn int", sms_yn!)
        
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "회원가입"
        
        nameInput.addLeftPadding()
        emailInput.addLeftPadding()
        passwordInput.addLeftPadding()
        passwordCheckInput.addLeftPadding()
        telInput.addLeftPadding()
        
        nameInput.tag = 0
        emailInput.tag = 1
        passwordInput.tag = 2
        passwordCheckInput.tag = 3
        telInput.tag = 4
        
        nameInput.addLeftPadding()
        emailInput.addLeftPadding()
        passwordInput.addLeftPadding()
        passwordCheckInput.addLeftPadding()
        telInput.addLeftPadding()
        
        
        nameInput.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        emailInput.attributedPlaceholder = NSAttributedString(string: "아이디(Email)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        passwordInput.attributedPlaceholder = NSAttributedString(string: "비밀번호(영어, 숫자, 특수문자를 포함한 8 ~ 20자)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)]) // 8자리 ~ 50자리 영어+숫자+특수문자
        passwordCheckInput.attributedPlaceholder = NSAttributedString(string: "비밀번호 재확인", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        telInput.attributedPlaceholder = NSAttributedString(string: "핸드폰 번호", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        btnConfirm.layer.cornerRadius = 10
        btnConfirm.layer.borderWidth = 0
//        btnConfirm.layer.borderColor = UIColor.init(displayP3Red: 241/255, green: 255/255, blue: 255/255, alpha: 1)
        
        
        //로그인버튼 색깔 변경
        self.nameInput.addTarget(self, action: #selector(self.loginButtonBackGroundColor(_:)), for: .editingChanged)
        self.emailInput.addTarget(self, action: #selector(self.loginButtonBackGroundColor(_:)), for: .editingChanged)
        self.passwordInput.addTarget(self, action: #selector(self.loginButtonBackGroundColor(_:)), for: .editingChanged)
        self.passwordCheckInput.addTarget(self, action: #selector(self.loginButtonBackGroundColor(_:)), for: .editingChanged)
        self.telInput.addTarget(self, action: #selector(self.loginButtonBackGroundColor(_:)), for: .editingChanged)
        
        //이메일 유효성검사(중복, 유효)
        self.emailInput.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        //핸드폰 번호('-' format)
        self.telInput.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
        nameInput.delegate = self
        emailInput.delegate = self
        passwordInput.delegate = self
        passwordCheckInput.delegate = self
        telInput.delegate = self
        
        telInput.keyboardType = .phonePad
        
        
    }
    
    override func viewDidLayoutSubviews() {
        labelSetColor()
    }
    
    func labelSetColor(){
        let attributedStr1 = NSMutableAttributedString(string: descriptionLabel.text!)
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (descriptionLabel.text! as NSString).range(of: "아이디 / 비밀번호 찾기"))
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (descriptionLabel.text! as NSString).range(of: "실사용 중"))
        descriptionLabel.attributedText = attributedStr1
    }
    
    func telInputSetUp(){
        telInput.text = phoneNumber
        telInput.isEnabled = false
        telInput.backgroundColor = .systemGray5
    }
    
    func setupLayout(){
        btnConfirm.layer.cornerRadius = 5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        email = emailInput.text
        
        if(email != ""){
            if !(email?.validateEmail(email!) ?? true) { // 정규식 false 일때
                emailCheckText!.text! = "Email형식으로 입력해주세요."
                emailCheckText.textColor = UIColor.red
                emailInput.layer.borderWidth = 1
                emailInput.layer.borderColor = UIColor.red.cgColor
                registerEnable = false
            } else if (requestGet(user_id : email!, requestUrl : "/duplicationid")) {
                emailCheckText!.text! = "중복된 Email입니다."
                emailCheckText.textColor = UIColor.red
                emailInput.layer.borderWidth = 1
                emailInput.layer.borderColor = UIColor.red.cgColor
                registerEnable = false
            } else{
                emailCheckText!.text! = "사용 가능한 Email입니다."
                emailCheckText.textColor = UIColor.systemGreen
                emailInput.layer.borderWidth = 2
                emailInput.layer.borderColor = UIColor.systemGreen.cgColor
                registerEnable = true
            }
        }
        
    }
    
    
    
    @objc func loginButtonBackGroundColor(_ textField: UITextField) {
        name = nameInput.text
        email = emailInput.text
        password = passwordInput.text
        passwordCheck = passwordCheckInput.text
        telNumber = telInput.text
        
        if textField.tag == 0 {
            checkMaxLength(textField: nameInput, maxLength: 20)
        }else if textField.tag == 1 {
            checkMaxLength(textField: emailInput, maxLength: 30)
        }else if textField.tag == 2 {
            checkMaxLength(textField: passwordInput, maxLength: 20)
        }else if textField.tag == 3 {
            checkMaxLength(textField: passwordCheckInput, maxLength: 20)
        }
        
        if(name != "" && email != "" && password != "" && passwordCheck != "" && telNumber != ""){
            btnConfirm.layer.backgroundColor = UIColor.systemBlue.cgColor
            btnConfirm.isEnabled = true
        } else if (name == "" || email == "" || password == "" || passwordCheck == "" || telNumber == ""){
            btnConfirm.layer.backgroundColor = UIColor.systemGray2.cgColor
            btnConfirm.isEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkMaxLength(textField: telInput, maxLength: 13)
        guard let text = telInput.text else { return }
        telInput.text = phoneFormat.addCharacter(at: text)
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (emailInput.text?.count ?? 0 > maxLength) {
                emailInput.deleteBackward()
            }
        }else if textField.tag == 1 {
            if (emailInput.text?.count ?? 0 > maxLength) {
                emailInput.deleteBackward()
            }
        }else if textField.tag == 2 {
            if (passwordInput.text?.count ?? 0 > maxLength) {
                passwordInput.deleteBackward()
            }
        }else if textField.tag == 3 {
            if (passwordCheckInput.text?.count ?? 0 > maxLength) {
                passwordCheckInput.deleteBackward()
            }
        }else if textField.tag == 4 {
            if (telInput.text?.count ?? 0 > maxLength) {
                telInput.deleteBackward()
            }
        }
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        name = nameInput.text
        email = emailInput.text
        password = passwordInput.text
        passwordCheck = passwordCheckInput.text
        telNumber = telInput.text
        telNumber = telNumber!.replacingOccurrences(of: "-", with: "")
        
        print("email", email?.validateEmail(email!) ?? true)
        print("password", password?.validatePassword(password!) ?? true)
        print("telNumber", telNumber!)
        
        if name == "" || email == "" || password == "" || passwordCheck == "" || telNumber == ""{
            self.normalAlert(titles: "알림", messages: "빈칸없이 작성해주세요.")
        } else if !(email?.validateEmail(email!) ?? true) {
            emailInput.becomeFirstResponder()
            self.normalAlert(titles: "알림", messages: "아이디(Email)를 확인해주세요.")
        } else if !(password?.validatePassword(password!) ?? true) {
            passwordInput.becomeFirstResponder()
            self.normalAlert(titles: "알림", messages: "비밀번호를 확인해주세요. 비밀번호(영어, 숫자, 특수문자를 포함한 8 ~ 20자)")
        } else if password != passwordCheck {
            passwordInput.becomeFirstResponder()
            self.normalAlert(titles: "알림", messages: "비밀번호, 비밀번호 재확인이 일치하지 않습니다.")
        } else if !(telNumber?.validatePhoneNumber(telNumber!) ?? true) {
            telInput.becomeFirstResponder()
            self.normalAlert(titles: "알림", messages: "휴대폰 번호를 확인해주세요.")
        } else{
            profile["name"] = name!
            profile["user_id"] = email!
            profile["user_password"] = password!
            profile["password"] = password!
            
            print("profile ... # ", profile)
            if(!registerEnable){ // 이메일 유효성검사(중복, 유효시)
                emailInput.becomeFirstResponder()
                self.normalAlert(titles: "알림", messages: "아이디(Email)를 확인해주세요.")
            } else{
                requestPost(requestUrl: "/register")
            }
            
        }
        

        
        
    }
    
    func requestGet(user_id : String!, requestUrl : String!) -> Bool{
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl+"?user_id="+user_id!)
            let response = try String(contentsOf: url!)
            
//            print("success")
            print("#########response", response)
            print(type(of: response))
            if response == "true"{
                return true;
            } else if response == "false"{
                return false;
            } else{
                return false;
            }
        } catch let e as NSError {
            print(e.localizedDescription)
            return false;
        }
    }
    
    func requestPost(requestUrl : String!) -> Void{
        let name = nameInput.text
        let email = emailInput.text
        let password = passwordInput.text
        let telNumber = telInput.text
        let param = ["user_id" : email, "name" : name, "user_password" : password, "phone_number" : telNumber, "email_yn" : email_yn, "sms_yn" : sms_yn] as [String : Any] // JSON 객체로 전송할 딕셔너리
//        let param = "user_Id=\(email)&name=\(name)"
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
//                request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
//                request.setValue(String(paramData.count), forHTTPHeaderField: "Content-Length")
                
                // URLSession 객체를 통해 전송, 응답값 처리
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    if(responseString == "true"){
                        DispatchQueue.main.async{ [self] in
//                        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "viewVC")
//                        self.navigationController?.pushViewController(pushVC!, animated: true)
                            if let viewControllers = self.navigationController?.viewControllers {
                                if viewControllers.count > 4 {
                                    print("ㅇㅇㅇㅇㅇ\(#line)")
                                    self.navigationController?.popToViewController(viewControllers[viewControllers.count - 4], animated: true)
                                    self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "회원가입 완료", completeTitle: "확인", nil)
                                } else {
                                            // fail
                                }
                            }
                        }
                    }else{
                        DispatchQueue.main.async{
                            self.normalAlert(titles: "회원가입 오류", messages: nil)
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func normalAlert(titles:String, messages:String?) -> Void{
        if messages != nil{
            let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        } else{
            let alert = UIAlertController(title: titles, message: nil, preferredStyle: UIAlertController.Style.alert)
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
            present(alert, animated: true, completion: nil)
        }
        
        
//        alert.addAction(defaultAction)
//        present(alert, animated: true, completion: nil)
    }
    
}
