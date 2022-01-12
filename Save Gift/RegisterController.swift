//
//  RegisterController.swift
//  Save Gift/Users/ukbook/Desktop/Save Gift/Save Gift/ViewController.swift
//
//  Created by ukBook on 2021/12/05.
//  회원가입1

import UIKit


//약관동의 controller
class RegisterController: UIViewController {
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var pushButton: UIButton!
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var wholeButton: UIButton!
    var necessary : Bool = false;
    var whole : Bool = false;
    var marketing : Bool = false;
    var push : Bool = false;
    var email : Bool = false;
    var sms : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
//        let rightBarButton = UIBarButtonItem.init(title: "확인", style: .plain, target: self, action: #selector(self.actionA)) //Class.MethodName
//        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "약관동의"

        firstButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        firstButton.titleEdgeInsets  = UIEdgeInsets(top: 0, left: 26.5, bottom: 0, right: 0)
        secondButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 18, bottom: 0, right: 0)
        secondButton.titleEdgeInsets  = UIEdgeInsets(top: 0, left: 26.5, bottom: 0, right: 0)
        thirdButton.titleEdgeInsets  = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc func actionA() -> Void {
        print("dd")
    }
    @IBAction func wholeBtnAction(_ sender: Any) {
        whole = !whole
        
        if whole {
            necessary = true
            marketing = true
            push = true
            email = true
            sms = true
            
            wholeButton.tintColor = UIColor.systemBlue
            firstButton.tintColor = UIColor.systemBlue
            secondButton.tintColor = UIColor.systemBlue
            pushButton.tintColor = UIColor.systemBlue
            emailButton.tintColor = UIColor.systemBlue
            smsButton.tintColor = UIColor.systemBlue
        } else{
            necessary = false
            marketing = false
            push = false
            email = false
            sms = false
            
            wholeButton.tintColor = UIColor.lightGray
            firstButton.tintColor = UIColor.lightGray
            secondButton.tintColor = UIColor.lightGray
            pushButton.tintColor = UIColor.lightGray
            emailButton.tintColor = UIColor.lightGray
            smsButton.tintColor = UIColor.lightGray
        }
        
        if necessary {
            nextButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        } else{
            nextButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    @IBAction func firstBtnAction(_ sender: Any) {
//        print(necessary)
        necessary = !necessary
        
        if necessary {
            firstButton.tintColor = UIColor.systemBlue
            nextButton.layer.backgroundColor = UIColor.systemBlue.cgColor
        } else{
            firstButton.tintColor = UIColor.lightGray
            nextButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
        
        if necessary && marketing && push && email && sms{
            wholeButton.tintColor = UIColor.systemBlue
        } else{
            wholeButton.tintColor = UIColor.lightGray
        }
    }
    @IBAction func secondBtnAction(_ sender: Any) {
        marketing = !marketing
        push = !push
        email = !email
        sms = !sms
        
        if marketing {
            marketing = true
            push = true
            email = true
            sms = true
            
            secondButton.tintColor = UIColor.systemBlue
            pushButton.tintColor = UIColor.systemBlue
            emailButton.tintColor = UIColor.systemBlue
            smsButton.tintColor = UIColor.systemBlue
        } else{
            marketing = false
            push = false
            email = false
            sms = false
            
            secondButton.tintColor = UIColor.lightGray
            pushButton.tintColor = UIColor.lightGray
            emailButton.tintColor = UIColor.lightGray
            smsButton.tintColor = UIColor.lightGray
        }
        
        if necessary && marketing && push && email && sms{
            wholeButton.tintColor = UIColor.systemBlue
        } else{
            wholeButton.tintColor = UIColor.lightGray
        }
        
        
        print("마켓팅 수신 전체 동의")
        print("marketing ", String(marketing))
        print("push ", String(push))
        print("email ", String(email))
        print("sms ", String(sms))
    }
    //푸시
    @IBAction func pushBtnAction(_ sender: Any) {
        push = !push
        
        //push 단독
        if push {
            pushButton.tintColor = UIColor.systemBlue
        } else{
            pushButton.tintColor = UIColor.lightGray
        }
        
        //마켓팅 수신 전체동의
        if push && email && sms {
            marketing = true
            secondButton.tintColor = UIColor.systemBlue
        } else{
            marketing = false
            secondButton.tintColor = UIColor.lightGray
        }
        
        //전체동의
        if necessary && marketing && push && email && sms{
            wholeButton.tintColor = UIColor.systemBlue
        } else{
            wholeButton.tintColor = UIColor.lightGray
        }
        print("marketing ", String(marketing))
        print("push ", String(push))
        print("email ", String(email))
        print("sms ", String(sms))
    }
    //이메일
    @IBAction func emailBtnAction(_ sender: Any) {
        email = !email
        
        if email {
            emailButton.tintColor = UIColor.systemBlue
        } else{
            emailButton.tintColor = UIColor.lightGray
        }
        
        //마켓팅 수신 전체동의
        if push && email && sms {
            marketing = true
            secondButton.tintColor = UIColor.systemBlue
        } else{
            marketing = false
            secondButton.tintColor = UIColor.lightGray
        }
        
        //전체동의
        if necessary && marketing && push && email && sms{
            wholeButton.tintColor = UIColor.systemBlue
        } else{
            wholeButton.tintColor = UIColor.lightGray
        }
        
        print("marketing ", String(marketing))
        print("push ", String(push))
        print("email ", String(email))
        print("sms ", String(sms))
    }
    //에스엠에스
    @IBAction func smsBtnAction(_ sender: Any) {
        sms = !sms
        
        if sms {
            smsButton.tintColor = UIColor.systemBlue
        } else{
            smsButton.tintColor = UIColor.lightGray
        }
        
        //마켓팅 수신 전체동의
        if push && email && sms {
            marketing = true
            secondButton.tintColor = UIColor.systemBlue
        } else{
            marketing = false
            secondButton.tintColor = UIColor.lightGray
        }
        
        //전체동의
        if necessary && marketing && push && email && sms{
            wholeButton.tintColor = UIColor.systemBlue
        } else{
            wholeButton.tintColor = UIColor.lightGray
        }
        
        print("marketing ", String(marketing))
        print("push ", String(push))
        print("email ", String(email))
        print("sms ", String(sms))
    }
    @IBAction func nextBtnAction(_ sender: Any) {
        if necessary {
//            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "Register3")
            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "Register3") as? Register3Controller else{
                return
            }
            
            pushVC.pushYn = push
            pushVC.emailYn = email
            pushVC.smsYn = sms
                    self.navigationController?.pushViewController(pushVC, animated: true)
            
            let backBarButtonItem = UIBarButtonItem(title: "약관동의", style: .plain, target: self, action: nil)
            self.navigationItem.backBarButtonItem = backBarButtonItem
        } else{
            normalAlert(titles: "(필수) 약관에 동의해야 합니다", messages: "zz")
        }
    }
    func normalAlert(titles:String, messages:String) -> Void{
        let alert = UIAlertController(title: titles, message: nil, preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler : nil)
        
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
}
