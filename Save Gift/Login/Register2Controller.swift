//
//  Register2Controller.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/10.
//

import UIKit
import JSPhoneFormat

class Register2Controller: UIViewController {
    let LOG_TAG = "Register2Controller"
    let helper = Helper()
    @IBOutlet weak var cellPhoneTextField: UITextField!
    @IBOutlet weak var authNumberTextField: UITextField! // 인증번호 자동완성 https://swieeft.github.io/2020/08/13/MobileAuthNumberAutomaticCompletion.html
    
    @IBOutlet weak var authRequestBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var description1: UILabel!
    @IBOutlet weak var description2: UILabel!
    @IBOutlet weak var description3: UILabel!
    
    var emailYn : Bool?
    var smsYn : Bool?
    
    var nextBool : Bool = false
    
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")   //구분자로 사용하고싶은 캐릭터를 넣어주시면 됩니다.
    let border1 = CALayer()
    let border2 = CALayer()
    
    var count = 59
    
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
        cellPhoneTextField.borderStyle = .none
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
        self.authNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        authNumberTextField.tag = 1
        
        authNumberTextField.keyboardType = .phonePad
        
        authNumberTextField.addLeftPadding()
        authNumberTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: authNumberTextField.frame.size.height-1, width: authNumberTextField.frame.width, height: 0)
        border1.backgroundColor = UIColor.lightGray.cgColor
        authNumberTextField.layer.addSublayer((border1))
        authNumberTextField.textAlignment = .left
        authNumberTextField.textColor = UIColor.black
        authNumberTextField.attributedPlaceholder = NSAttributedString(string: "인증번호 6자리 입력", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
    }
    
    override func viewDidLoad() {
        print("viewDidLoad Register2Controller")
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
//        let rightBarButton = UIBarButtonItem.init(title: "확인", style: .plain, target: self, action: #selector(self.actionA)) //Class.MethodName
//        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.title = "휴대폰 인증"
        
        labelSetColor()
        var timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellPhoneTextField.text = ""
        
        authNumberTextField.text = ""
        authNumberTextField.isEnabled = false
        authNumberTextField.backgroundColor = .systemGray5
        
        authRequestBtn.isEnabled = false
        authRequestBtn.backgroundColor = .systemGray2
        authRequestBtn.setTitle("인증 요청", for: .normal)
        
        nextBtn.backgroundColor = .systemGray2
        nextBtn.isEnabled = false
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0{
            checkMaxLength(textField: cellPhoneTextField, maxLength: 13)
            guard let text = cellPhoneTextField.text else { return }
            cellPhoneTextField.text = phoneFormat.addCharacter(at: text)
            if text.count == 13{
                authRequestBtn.backgroundColor = .systemBlue
                authRequestBtn.isEnabled = true
            }else {
                authRequestBtn.backgroundColor = .systemGray2
                authRequestBtn.isEnabled = false
            }
        }else if textField.tag == 1{
            checkMaxLength(textField: authNumberTextField, maxLength: 6)
        }
        if nextBool{
            if authNumberTextField.text?.count == 6 && cellPhoneTextField.text?.count == 13{
                nextBtn.backgroundColor = .systemBlue
                nextBtn.isEnabled = true
            }else {
                nextBtn.backgroundColor = .systemGray2
                nextBtn.isEnabled = false
            }
        }
        
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (cellPhoneTextField.text?.count ?? 0 > maxLength) {
                cellPhoneTextField.deleteBackward()
            }
        }else if textField.tag == 1 {
            if (authNumberTextField.text?.count ?? 0 > maxLength) {
                authNumberTextField.deleteBackward()
            }
        }
        
    }
    
    func labelSetColor(){
//         NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr1 = NSMutableAttributedString(string: description1.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (description1.text! as NSString).range(of: "6자리 인증번호"))
        // 설정이 적용된 text를 label의 attributedText에 저장
        description1.attributedText = attributedStr1
        
        let attributedStr2 = NSMutableAttributedString(string: description2.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr2.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (description2.text! as NSString).range(of: "재전송"))
        // 설정이 적용된 text를 label의 attributedText에 저장
        description2.attributedText = attributedStr2
        
        let attributedStr3 = NSMutableAttributedString(string: description3.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr3.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (description3.text! as NSString).range(of: "3번 이상 인증 실패 시, 하루동안 인증이 제한됩니다. (00시 기준 리셋)"))
        // 설정이 적용된 text를 label의 attributedText에 저장
        description3.attributedText = attributedStr3
    }
    
    @IBAction func authRequestAction(_ sender: Any) {
        authRequestBtn.setTitle("재전송", for: .normal)
        print("\(cellPhoneTextField.text!)")
        helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "인증번호가 핸드폰으로 전송되었습니다.", completeTitle: "확인", nil)
        //server request true/false 이후 nextBool 변경
        authNumberTextField.isEnabled = true
        authNumberTextField.backgroundColor = .white
        nextBool = true // 임시
        
    }
    @IBAction func nextAction(_ sender: Any) {
        print("다음")
//        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "Register3")
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "Register3") as? Register3Controller else{
            return
        }
        
        pushVC.emailYn = emailYn!
        pushVC.smsYn = smsYn!
        pushVC.phoneNumber = cellPhoneTextField.text!
        
        self.navigationController?.pushViewController(pushVC, animated: true)
    }
    
    @objc func update() {
        if(count > 0) {
//            countDownLabel.text = String(count--)
            print("\(count) !!!")
            count-=1
        }else {
            count = 60
        }
    }
}

