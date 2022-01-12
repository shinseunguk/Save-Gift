import UIKit

extension UITextField {
    
    func addLeftPadding() {
      let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: self.frame.height))
      self.leftView = paddingView
      self.leftViewMode = ViewMode.always
    }

    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButtonOnKeyboard()
            }
        }
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension String {
    
    // 핸드폰 번호 정규성 체크
    func validatePhoneNumber(_ input: String) -> Bool {

        let regex = "^01[0-1, 7][0-9]{7,8}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = phonePredicate.evaluate(with: input)

        print("isValid", String())
        if isValid {
            return true
        } else {
            return false
        }
    }

    // 이메일 정규성 체크
    func validateEmail(_ input: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = emailPredicate.evaluate(with: input)

        if isValid {
            return true
        } else {
            return false
        }
    }

    // 패스워드 정규성 체크
    func validatePassword(_ input: String) -> Bool {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}" // 8자리 ~ 50자리 영어+숫자+특수문자

        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: input)

        if isValid {
            return true
        } else {
            return false
        }
    }
    
    func getLocalURL() -> String{
        return "http://172.30.1.48:8008"
    }
}



