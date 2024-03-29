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

class ViewController: UIViewController, ASAuthorizationControllerDelegate, UITextFieldDelegate{
    let LOG_TAG : String = "ViewController"

    

    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnAppleLogin: UIButton!
    @IBOutlet weak var btnKakaoLogin: UIButton!
    @IBOutlet weak var btnNaverLogin: UIButton!
    @IBOutlet weak var btnFindPW: UIButton!
    @IBOutlet weak var btnFindID: UIButton!
    
    
    // Storyboard
    @IBOutlet weak var appleSignInButton: UIStackView!

    let localUrl = "".getLocalURL();
    let helper : Helper = Helper();
    let deviceID = UIDevice.current.identifierForVendor!.uuidString
    
    var url : String = ""
    var id: String = ""
    var pw: String = ""
    let border1 = CALayer()
    let border2 = CALayer()
    var navigationBarBackButtonTitle : String?
    var VC : String?
    var dic : [String: Any] = [:];
    //DeviceId
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ViewController viewDidLoad")
        
        setupLayout()
        
        if VC != nil{
            print("### ",VC!)
            
        }
        //첫 진입시 버튼 사용할수 없음
        btnLogin.isEnabled = false
        
        //테스트 해볼것
        idTextField.keyboardType = .emailAddress
        self.idTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        idTextField.tag = 0
        passwordTextField.tag = 1
        
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
        if textField.tag == 0{ //id textField
            checkMaxLength(textField: idTextField, maxLength: 30)
        }else { //pw textField
            checkMaxLength(textField: passwordTextField, maxLength: 20)
        }
        
        if(id != "" && pw != ""){
            btnLogin.layer.backgroundColor = UIColor.systemBlue.cgColor
            btnLogin.isEnabled = true
        } else if (id == "" || pw == ""){
            btnLogin.layer.backgroundColor = UIColor.systemGray2.cgColor
            btnLogin.isEnabled = false
        }
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (idTextField.text?.count ?? 0 > maxLength) {
                idTextField.deleteBackward()
            }
        }else if textField.tag == 1{
            if (passwordTextField.text?.count ?? 0 > maxLength) {
                passwordTextField.deleteBackward()
            }
        }
    }
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
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
    
    func setupLayout(){
        
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
        
        btnRegister.layer.cornerRadius = 5
        btnLogin.layer.cornerRadius = 5
        btnFindID.layer.cornerRadius = 5
        btnFindPW.layer.cornerRadius = 5
    }

    @IBAction func loginAction(_ sender: Any) {
        id = idTextField.text!
        pw = passwordTextField.text!
        
        if id != "" && pw != ""{
            //DB처리 필요
            requestPost(requestUrl : "/login")
        }
    }
    
    func requestPost(requestUrl : String!) -> Void{
        let email = idTextField.text
        let password = passwordTextField.text
        let param = ["user_id" : email, "user_password" : password, "device_id" : deviceID] as [String : Any] // JSON 객체로 전송할 딕셔너리
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
                    
                    if(responseString == "true"){ // 로그인 완료
                        DispatchQueue.main.async{
//                            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "tabbarVC") as? CustomTabBarController else{
//                                return
//                            }
//
//                            pushVC.VC = self.VC
//                            self.navigationController?.pushViewController(pushVC, animated: true)
                            
//                        //화면 Stack으로 인해 6월 29일 poptoviewcontroller 방식으로 교체
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                        print("\(#line) ", viewControllers)
                        for aViewController in viewControllers {
                            if aViewController is UnlockController {
                                self.navigationController!.popToViewController(aViewController, animated: true)
                            }
                        }
                            
                        // 아이디저장
                        UserDefaults.standard.set(email, forKey: "ID")
                            
                            self.requestGet(user_id : UserDefaults.standard.string(forKey: "ID")! , requestUrl : "/status")
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
    
    func requestGet(user_id : String!, requestUrl : String!){
        do {
            // URL 설정 GET 방식으로 호출
            let url = URL(string: localUrl+requestUrl+"?user_id="+user_id!)
            let response = try String(contentsOf: url!)
            
//            print("success")
            print("#########response", response)
            dic = helper.jsonParserName(stringData: response, data1: "name");
            
            print("#############################",dic["name"]!)
            if(dic["name"] != nil){
                UserDefaults.standard.set(dic["name"]!, forKey: "name")
            }
            
            
        } catch let e as NSError {
            print(e.localizedDescription)
        }
    
    }
    
    //애플 로그인
    @IBAction func appleAction(_ sender: Any) {
        print("애플 로그인")
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

//                    let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "tabbarVC")
//                            self.navigationController?.pushViewController(pushVC!, animated: true)
                    let viewControllers: [UIViewController] = self.navigationController!.viewControllers
                    print("\(#line) ", viewControllers)
                    for aViewController in viewControllers {
                        if aViewController is UnlockController {
                            self.navigationController!.popToViewController(aViewController, animated: true)
                        }
                    }
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
    
    
    //네이버 로그인
    @IBAction func naverAction(_ sender: Any) {
        print("naver")
    }
    
    //아이디에서 엔터
    @IBAction func idAction(_ sender: Any) {
        self.passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func findPWAction(_ sender: Any) {
        print("findPWAction")
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "FindpwController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    // 아이디 찾기
    @IBAction func findIDAction(_ sender: Any) {
        print("findAction")
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "FindidController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "로그인", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
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

extension ViewController : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
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
        print("Apple ID 연동 실패 error")
        // Handle error.
    }
    
}
