//
//  Register2Controller.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/10.
//

import UIKit
import JSPhoneFormat

class Register2Controller: UIViewController {
    
    @IBOutlet weak var cellPhoneTextField: UITextField!
    
    let phoneFormat = JSPhoneFormat.init(appenCharacter: "-")   //구분자로 사용하고싶은 캐릭터를 넣어주시면 됩니다.
    let border1 = CALayer()
    let border2 = CALayer()
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        self.cellPhoneTextField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
        
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
//        self.navigationItem.title = "휴대폰 인증"

    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        checkMaxLength(textField: cellPhoneTextField, maxLength: 13)
        guard let text = cellPhoneTextField.text else { return }
        cellPhoneTextField.text = phoneFormat.addCharacter(at: text)
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
    
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (cellPhoneTextField.text?.count ?? 0 > maxLength) {
            cellPhoneTextField.deleteBackward()
        }
    }
    @IBAction func needCertificationNumber(_ sender: Any) {
        print("인증번호 요청 touch")
    }
    @IBAction func skipAction(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "Register3")
                self.navigationController?.pushViewController(pushVC!, animated: true)
        
        let backBarButtonItem = UIBarButtonItem(title: "휴대폰 인증", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    @IBAction func nextAction(_ sender: Any) {
        print("다음")
    }
}

