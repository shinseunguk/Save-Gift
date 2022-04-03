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
    
    // 날짜 정규식 체크
    func validateDate(_ input: String) -> String {
//        let datePattern: String = "(?<year>[0-9]{2,4})[-/.](?<month>[0-9]{2})[-/.](?<date>[0-9]{2})"
//        let regex = try? NSRegularExpression(pattern: datePattern, options: [])
//
//        if let result = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
//            let rexStrings = result.map { (element) -> String in
//                let yearRange = Range(element.range(withName: "year"), in: input)!
//                let monthRange = Range(element.range(withName: "month"), in: input)!
//                let dateRange = Range(element.range(withName: "date"), in: input)!
////                validateMonth(input[yearRange])
//                return "\(input[yearRange])\(input[monthRange])\(input[dateRange])"
//            }
//            print("rexStrings  ",rexStrings)
//        }
//        if isValid {
//            return true
//        } else {
//            return false
//        }
        
        let helper : Helper = Helper()
        let date = helper.formatDateToday()
        let todayYear = date.substring(from: 0, to: 3) // today 년
        let todayMonth = date.substring(from: 4, to: 5) // today 월
        let todayDay = date.substring(from: 6, to: 7) // today 일
        
        if !validateYear(text: input) { // 정규식 이상있음.
            return "\(todayYear)년 이후로 입력해주세요."
        } else if !validateMonth(text: input) {
            return "1월 ~ 12월을 입력해주세요."
        } else if validateDay(text: input) != ""{
            return validateDay(text: input)
        } else {
            return ""
        }
    }
    
    func validateYear(text : String) -> Bool {
        let helper : Helper = Helper()
        
        let date = helper.formatDateToday()
        let todayYear = date.substring(from: 0, to: 3) // 오늘년도
        let inputYear = text.substring(from: 0, to: 3) // 입력년도
        print("todayYear ", todayYear)
        print("inputYear ", inputYear)
        
        if todayYear <= inputYear { // 정규식 이상없음.
            return true
        }else {
            return false
        }
        
    }
    
    func validateMonth(text : String) -> Bool {
        let helper : Helper = Helper()
        
        let inputMonth = text.substring(from: 4, to: 5) // 입력년도
        print("inputMonth ", inputMonth)
        
        switch inputMonth {
        case "01":
            return true
        case "02":
            return true
        case "03":
            return true
        case "04":
            return true
        case "05":
            return true
        case "06":
            return true
        case "07":
            return true
        case "08":
            return true
        case "09":
            return true
        case "10":
            return true
        case "11":
            return true
        case "12":
            return true
        default:
            return false
        }
        
    }
    
    func validateDay(text : String) -> String {
        let helper : Helper = Helper()
        
        let inputYear = text.substring(from: 0, to: 3) // 입력년도
        let inputMonth = text.substring(from: 4, to: 5) // 입력월
        let inputDay = text.substring(from: 6, to: 7) // 입력일
        var inputYearInt = Int(inputYear)
        var inputDayInt = Int(inputDay)
        print("inputYear ", inputYear)
        print("inputMonth ", inputMonth)
        print("inputDayInt ", inputDayInt!)
        
        switch inputMonth {
        case "01":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "1월은 1일~31일 값을 입력해주세요."
            }
        case "02":
            if inputYearInt! % 4 == 0 && (inputYearInt! % 100 != 0 || inputYearInt! % 400 == 0) {
                if 1 <= inputDayInt! && inputDayInt! <= 29 {
                    return ""
                }else {
                    return "\(inputYearInt!)년 2월은 1일~29일 값을 입력해주세요."
                }
            } else {
                if 1 <= inputDayInt! && inputDayInt! <= 28 {
                    return ""
                }else {
                    return "\(inputYearInt!)년 2월은 1일~28일 값을 입력해주세요."
                }
            }

        case "03":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "3월은 1일~31일 값을 입력해주세요."
            }
        case "04":
            if 1 <= inputDayInt! && inputDayInt! <= 30{
                return ""
            }else {
                return "4월은 1일~30일 값을 입력해주세요."
            }
        case "05":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "5월은 1일~31일 값을 입력해주세요."
            }
        case "06":
            if 1 <= inputDayInt! && inputDayInt! <= 30{
                return ""
            }else {
                return "6월은 1일~30일 값을 입력해주세요."
            }
        case "07":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "7월은 1일~31일 값을 입력해주세요."
            }
        case "08":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "8월은 1일~31일 값을 입력해주세요."
            }
        case "09":
            if 1 <= inputDayInt! && inputDayInt! <= 30{
                return ""
            }else {
                return "9월은 1일~30일 값을 입력해주세요."
            }
        case "10":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "10월은 1일~31일 값을 입력해주세요."
            }
        case "11":
            if 1 <= inputDayInt! && inputDayInt! <= 30{
                return ""
            }else {
                return "11월은 1일~30일 값을 입력해주세요."
            }
        case "12":
            if 1 <= inputDayInt! && inputDayInt! <= 31{
                return ""
            }else {
                return "12월은 1일~31일 값을 입력해주세요."
            }
        default:
            print("default")
            return ""
        }
    }
    
    func hasCharacters() -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9a-zA-Z가-힣ㄱ-ㅎㅏ-ㅣ`~!@#$%^&*()\\-_=+\\[{\\]}\\\\|;:'\",<.>/?\\s]$", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
                return true
            }
        }catch {
            return false
        }
        return false
    }

    
    // 문자열 자르기
    func substring(from: Int, to: Int) -> String {
        guard from < count, to >= 0, to - from >= 0 else {
            return ""
        }
        
        // Index 값 획득
        let startIndex = index(self.startIndex, offsetBy: from)
        let endIndex = index(self.startIndex, offsetBy: to + 1) // '+1'이 있는 이유: endIndex는 문자열의 마지막 그 다음을 가리키기 때문
        
        // 파싱
        return String(self[startIndex ..< endIndex])
    }
    
    func getLocalURL() -> String{
//        return "http://175.212.211.98:8088" //집 공유기
        return "http://172.30.1.50:8088"
//        return "http://192.168.0.39:8008"
    }
}

extension UIImage {
    func resizeImage(image : UIImage, width : Float, height : Float) -> UIImage? {
         let cgWidth = CGFloat(width)
         let cgHeight = CGFloat(height)
        
            print("cgWdith ",cgWidth)
            print("cgHeight ",cgHeight)
         
         // Begine Context
         UIGraphicsBeginImageContext(CGSize(width: cgWidth, height: cgHeight))
         // Get Current Context
         let context = UIGraphicsGetCurrentContext()
         context?.translateBy(x : 0.0, y : cgHeight)
         context?.scaleBy(x: 1.0, y: -1.0)
         context?.draw(image.cgImage!, in: CGRect(x: 0.0, y: 0.0, width: cgWidth, height: cgHeight))
         let scaledImage : UIImage? = UIGraphicsGetImageFromCurrentImageContext()
         // End Context
         UIGraphicsEndImageContext()
         
         if (scaledImage != nil) {
             return scaledImage
         }
         else {
             return nil
         }
     }
}

