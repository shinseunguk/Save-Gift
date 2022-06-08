//
//  FindpwController.swift
//  Save Gift
//
//  Created by mac on 2022/06/07.
//

import Foundation
import UIKit
import JSPhoneFormat

class FindpwController : UIViewController{
    let LOG_TAG : String = "FindpwController"
    let helper = Helper()
    let localUrl = "".getLocalURL()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var authNumberTextField: UITextField!
    @IBOutlet weak var authBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var description1: UILabel!
    
    var nextBool : Bool = false
    
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
    
    override func viewDidLoad(){
        authNumberTextField.isEnabled = false
        authNumberTextField.backgroundColor = .systemGray5
        
        setNavTitle()
        labelSetColor()
    }
    
    override func viewDidLayoutSubviews() {
        // authNumberTextField
        self.nameTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.tag = 0
        
        
        nameTextField.addLeftPadding()
//        nameTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: nameTextField.frame.size.height-1, width: nameTextField.frame.width, height: 0)
        border1.backgroundColor = UIColor.lightGray.cgColor
        nameTextField.layer.addSublayer((border1))
        nameTextField.textAlignment = .left
        nameTextField.textColor = UIColor.black
        nameTextField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // cellPhoneTextField
        emailTextField.tag = 1
//        emailTextField.keyboardType = .phonePad

        emailTextField.addLeftPadding()
//        emailTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: emailTextField.frame.size.height-1, width: emailTextField.frame.width, height: 0)
        border1.backgroundColor = UIColor.lightGray.cgColor
        emailTextField.layer.addSublayer((border1))
        emailTextField.textAlignment = .left
        emailTextField.textColor = UIColor.black
        emailTextField.attributedPlaceholder = NSAttributedString(string: "아이디(Email)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        self.authNumberTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        // cellPhoneTextField
        authNumberTextField.tag = 2
//        emailTextField.keyboardType = .phonePad

        authNumberTextField.addLeftPadding()
//        emailTextField.borderStyle = .none
        border1.frame = CGRect(x: 0, y: authNumberTextField.frame.size.height-1, width: authNumberTextField.frame.width, height: 0)
        border1.backgroundColor = UIColor.lightGray.cgColor
        authNumberTextField.layer.addSublayer((border1))
        authNumberTextField.textAlignment = .left
        authNumberTextField.textColor = UIColor.black
        authNumberTextField.attributedPlaceholder = NSAttributedString(string: "인증번호 6자리", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
        
        nextBtn.layer.cornerRadius = 5
    }
    
    func setNavTitle(){
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "비밀번호 찾기"
    }
    
    func labelSetColor(){
//         NSMutableAttributedString Type으로 바꾼 text를 저장
        let attributedStr1 = NSMutableAttributedString(string: description1.text!)
        // text의 range 중에서 "Bonus"라는 글자는 UIColor를 blue로 변경
        attributedStr1.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (description1.text! as NSString).range(of: "이메일"))
        // 설정이 적용된 text를 label의 attributedText에 저장
        description1.attributedText = attributedStr1

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField.tag == 0{
            checkMaxLength(textField: nameTextField, maxLength: 10)
        }else if textField.tag == 1{
            checkMaxLength(textField: emailTextField, maxLength: 40)
            if (textField.text?.validateEmail(textField.text!) ?? false) { // 정규식 true 일때
                authBtn.backgroundColor = .systemBlue
                nextBtn.backgroundColor = .systemBlue
                nextBtn.isEnabled = true
            }else {
                authBtn.backgroundColor = .systemGray2
            }
        }else if textField.tag == 2{
            checkMaxLength(textField: authNumberTextField, maxLength: 6)
        }
        

        if nameTextField.text?.count != 0 && emailTextField.text?.count != 0 && authNumberTextField.text?.count == 6{
            if (emailTextField.text?.validateEmail(emailTextField.text!) ?? false) { // 정규식 true 일때
                nextBtn.backgroundColor = .systemBlue
                nextBtn.isEnabled = true
            }
        }else {
            nextBtn.backgroundColor = .systemGray2
            nextBtn.isEnabled = false
        }
    }
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if textField.tag == 0 {
            if (nameTextField.text?.count ?? 0 > maxLength) {
                nameTextField.deleteBackward()
            }
        }else if textField.tag == 1 {
            if (emailTextField.text?.count ?? 0 > maxLength) {
                emailTextField.deleteBackward()
            }
        }else if textField.tag == 2 {
            if (authNumberTextField.text?.count ?? 0 > maxLength) {
                authNumberTextField.deleteBackward()
            }
        }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        //화면이동
        print("nextAction")
    }
    
    @IBAction func authAction(_ sender: Any) {
        if (emailTextField.text?.validateEmail(emailTextField.text!) ?? false) { // 정규식 true 일때
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "해당 이메일로 인증번호가 전송되었습니다.", completeTitle: "확인", nil)
            authNumberTextField.isEnabled = true
            authNumberTextField.backgroundColor = .white
            authBtn.setTitle("재요청", for: .normal)
        }else {
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "이메일 형식으로 입력해주세요.", completeTitle: "확인", nil)
            emailTextField.becomeFirstResponder()
        }
    }
}
