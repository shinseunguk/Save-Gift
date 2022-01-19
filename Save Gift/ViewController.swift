//
//  ViewController.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/04.
// 로그인화면
// git testddㅇㅇdㅇㅇ 왜안될가 슈ㅜㄱ쟈ㅜㅕㅑ

import UIKit
import AuthenticationServices // 생체 인식
import KakaoSDKCommon // 카카오
import KakaoSDKAuth // 카카오
import KakaoSDKUser // 카카오
import Firebase

class ViewController: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, UITextFieldDelegate{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnKakaoLogin: UIButton!
    @IBOutlet weak var btnFacebookLogin: UIButton!
    @IBOutlet weak var btnNaverLogin: UIButton!
    
    
    // Storyboard
    @IBOutlet weak var appleSignInButton: UIStackView!

    let localUrl = "".getLocalURL();
    var url : String = ""
    var id: String = ""
    var pw: String = ""
    let border1 = CALayer()
    let border2 = CALayer()
    var navigationBarBackButtonTitle : String?
    var VC : String?
    //DeviceId
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        
        if VC != nil{
            print("### ",VC!)
            
        }
        //첫 진입시 버튼 사용할수 없음
        btnLogin.isEnabled = false
        
        //테스트 해볼것
        idTextField.keyboardType = .emailAddress
        self.idTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        
        //back버튼이 늘어나는 이슈
//        self.navigationController?.navigationBar.topItem?.title = ""
        
//        let rightBarButton = UIBarButtonItem.init(title: "확인", style: .plain, target: self, action: #selector(self.actionA)) //Class.MethodName
//        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "로그인"

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "로그인"
    }
    
    
    //로그인 버튼 enable
    func textFieldDidEndEditing(_ textField: UITextField) {
        id = idTextField.text!
        pw = passwordTextField.text!
        
        if(id != "" && pw != ""){
            btnLogin.layer.backgroundColor = UIColor.systemBlue.cgColor
            btnLogin.isEnabled = true
        } else if (id == "" || pw == ""){
            btnLogin.layer.backgroundColor = UIColor.systemGray2.cgColor
            btnLogin.isEnabled = false
        }
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
//        appTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 33.0)
        
        btnLogin.layer.cornerRadius = 10
        btnLogin.layer.borderWidth = 0
        btnLogin.layer.borderColor = UIColor.systemBlue.cgColor
        btnLogin.adjustsImageWhenHighlighted = false
        
        btnRegister.layer.cornerRadius = 10
        btnRegister.layer.borderWidth = 1
        btnRegister.layer.borderColor = UIColor.systemBlue.cgColor
        btnRegister.adjustsImageWhenHighlighted = false
        
        btnKakaoLogin.layer.cornerRadius = self.btnKakaoLogin.frame.size.height / 2
        btnKakaoLogin.layer.borderWidth = 0
        btnKakaoLogin.adjustsImageWhenHighlighted = false
        
        btnAppleLogin.layer.cornerRadius = self.btnAppleLogin.frame.size.height / 2
        btnAppleLogin.layer.borderWidth = 0
        btnAppleLogin.adjustsImageWhenHighlighted = false
        
        btnNaverLogin.layer.cornerRadius = self.btnNaverLogin.frame.size.height / 2
        btnNaverLogin.layer.borderWidth = 0
        btnNaverLogin.adjustsImageWhenHighlighted = false
        
        btnFacebookLogin.layer.cornerRadius = self.btnFacebookLogin.frame.size.height / 2
        btnFacebookLogin.layer.borderWidth = 0
        btnFacebookLogin.adjustsImageWhenHighlighted = false
        
        idTextField.addLeftPadding();
        idTextField.textAlignment = .left
        idTextField.textColor = UIColor.black
        idTextField.attributedPlaceholder = NSAttributedString(string: "아이디를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
//        idTextField.tintColor = UIColor.systemBlue
        
        passwordTextField.addLeftPadding();
//        passwordTextField.borderStyle = .none
//        border2.frame = CGRect(x: 0, y: passwordTextField.frame.size.height-1, width: passwordTextField.frame.width, height: 1)
//        border2.backgroundColor = UIColor.lightGray.cgColor
//        passwordTextField.layer.addSublayer((border2))
        passwordTextField.textAlignment = .left
        passwordTextField.textColor = UIColor.black
//        passwordTextField.placeholder = "PASSWORD"
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "비밀번호를 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
//        passwordTextField.tintColor = UIColor.systemBlue

    }

    @IBAction func loginAction(_ sender: Any) {
        id = idTextField.text!
        pw = passwordTextField.text!
        
        if id != "" && pw != ""{
            //DB처리 필요
            print(id + pw)
            requestPost(requestUrl : "/login")
        }
        
        //ㅌㅅㅌ용
        if id == "1" && pw == "1"{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                    self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    func requestPost(requestUrl : String!) -> Void{
        let email = idTextField.text
        let password = passwordTextField.text
        let param = ["user_id" : email, "user_password" : password] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
                        print("An error has occured: \(e.localizedDescription)")
                        return
                    }
                    
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("회원가입 응답 처리 로직 responseString", responseString!)
//                    print("응답 처리 로직 data", data as Any)
//                    print("응답 처리 로직 response", response as Any)
                    // 응답 처리 로직
                    
                    if(responseString == "true"){
                        DispatchQueue.main.async{
                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "tabbarVC") as? CustomTabBarController else{
                                return
                            }
                            
                            pushVC.VC = self.VC
                                
                            self.navigationController?.pushViewController(pushVC, animated: true)
                            
                        //저장
                        UserDefaults.standard.set(email, forKey: "ID")
                        }
                    } else if(responseString == "false"){
                        DispatchQueue.main.async{
                        self.normalAlert(titles: "로그인 실패", messages: "아이디와 비밀번호를 확인해주세요.")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    //애플 로그인
    @IBAction func appleAction(_ sender: Any) {
        handleAuthorizationAppleIDButtonPress()
    }
    
    //카카오 로그인
    @IBAction func kakaoAction(_ sender: Any) {
        print("kakao")
        
         // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    print("loginWithKakaoTalk() success.")

                    //do something
                    _ = oauthToken

                    self.setUserInfo()

                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                            self.navigationController?.pushViewController(pushVC!, animated: true)
                }
            }
        } else{
            self.openAppStore(appId: "kakao")
        }
    }
    
    func setUserInfo() -> Void {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else{
                print("me() success.")
                
                _ = user
//                print("#############",user?.kakaoAccount?.profile?.nickname as Any)
                print("#############",user?.kakaoAccount! as Any)
            }
        }
    }
    
    //페이스북 로그인
    @IBAction func facbookAction(_ sender: Any) {
        print("facebook")
    }
    
    //네이버 로그인
    @IBAction func naverAction(_ sender: Any) {
        print("naver")
    }
    
    //아이디에서 엔터
    @IBAction func idAction(_ sender: Any) {
        self.passwordTextField.becomeFirstResponder()
    }
    
    //패스워드에서 엔터
    @IBAction func pwAction(_ sender: Any) {
        id = idTextField.text!
        pw = passwordTextField.text!
        
        if id != "" && pw != ""{
            //DB처리 필요
            print(id + pw)
            requestPost(requestUrl : "/login")
        }
        
        //ㅌㅅㅌ용
        if id == "1" && pw == "1"{
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
                    self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "navPush")
                self.navigationController?.pushViewController(pushVC!, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
//        self.navigationController?.navigationBar.topItem?.title = "뒤로"
    }
    
    //핸드폰 번호 정규식
    func isPhone(candidate: String) -> Bool {
            let regex = "^01([0|1|6|7|8|9]?)-?([0-9]{3,4})-?([0-9]{4})$"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        }
        
    // 이메일 정규식
    func isEmail(candidate: String) -> Bool{
            let regex = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
            return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: candidate)
        }
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc
    func handleAuthorizationAppleIDButtonPress() {
        print("handleAuthorizationAppleIDButtonPress")
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
                
            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    
    //앱스토어 열기
    func openAppStore(appId: String) {

        print("openAppStore")
        if appId == "kakao"{
          url = "https://apps.apple.com/kr/app/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1-kakaotalk/id362057947"
        }else{
          url = "itms-apps://itunes.apple.com/app/" + appId;
        }
          
        
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}

