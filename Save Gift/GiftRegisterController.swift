//
//  GiftRegisterController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/16.
//

import Foundation
import UIKit
import MLKitCommon
import MLKitVision
import AVFoundation
import MLKitTextRecognitionKorean
import Firebase
import MLKitBarcodeScanning
import Vision
import VisionKit

class GiftRegisterController : UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    let imagePicker = UIImagePickerController()
    let helper : Helper = Helper()
    
    let arr = ["교환처", "상품명", "바코드 번호", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var arrTextField = ["", "", "", "", "", "", ""]
    var segmentStatus : Int = 0
    var registerButton = UIButton()
    var nextBool : Bool = false
    var s = 0
    var keyboard : Bool? = false
    
    let metadataObjectTypes: [AVMetadataObject.ObjectType] = [
                                                              .upce,
                                                              .code39,
                                                              .code39Mod43,
                                                              .code93,
                                                              .code128,
                                                              .ean8,
                                                              .ean13,
                                                              .aztec,
                                                              .pdf417,
                                                              .itf14,
                                                              .dataMatrix,
                                                              .interleaved2of5,
                                                              .qr
                                                             ]
    
    override func viewDidLoad() {
        super.viewDidLoad();

        self.imagePicker.delegate = self // picker delegate
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.allowsEditing = false // 수정 가능 여부
        self.scrollView.delegate = self
        

        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 등록 화면"
        
        // 등록일 Default Setting
        arrTextField.insert(helper.formatDateToday(), at: 5)
        // 등록자 Default Setting
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            arrTextField.insert("\(UserDefaults.standard.string(forKey: "ID")!)"+"(\(UserDefaults.standard.string(forKey: "name")!))", at: 6)
        }
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "plus"),  style: .plain, target: self, action: #selector(self.plusAction)) //Class.MethodName
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        imageView.addGestureRecognizer(tapGR)
                        imageView.isUserInteractionEnabled = true
        
        
        //버튼 점선
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        let frameSize = imageView.frame.size
//        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
//
//        shapeLayer.bounds = shapeRect
//                shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
//                shapeLayer.fillColor = UIColor.clear.cgColor
//                shapeLayer.strokeColor = UIColor.systemBlue.cgColor
//                shapeLayer.lineWidth = 2
//                shapeLayer.lineJoin = CAShapeLayerLineJoin.round
//                shapeLayer.lineDashPattern = [6,3]
//                shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath
//
//        imageView.layer.addSublayer(shapeLayer)
        
        //셀 테두리지우기
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //테이블뷰 선택 enable
        tableView.allowsSelection = false
        
        //Specify the xib file to use
        tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterTableViewCell")
        tableView.register(UINib(nibName: "RegisterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterUseTableViewCell")
        
        
        plusAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardNotifications()
    }

    
    func addKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // 노티피케이션을 제거하는 메서드
    func removeKeyboardNotifications(){
        // 키보드가 나타날 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification , object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 제거
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    
    @objc func keyboardWillHide(_ sender: Notification) {
        // 키보드의 높이만큼 화면을 내려준다.
        print("keyboardWillHide")
        if keyboard! {
            if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y += keyboardHeight
                
                keyboard = false
            }
        }
        
    }
    
        
    @objc func keyboardWillShow(_ sender: Notification) {
        print("keyboardWillShow")
        // 키보드의 높이만큼 화면을 올려준다.
        if !keyboard! {
            if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                self.view.frame.origin.y -= keyboardHeight
                
                keyboard = true
            }
        }
        
    }
    
    @objc
    func imageTapped(sender: UITapGestureRecognizer) {
                if sender.state == .ended {
                    print("imageTapped")
                    self.view.endEditing(true)
                }
        }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
         }
      }
    
    @objc func plusAction() {
        print("사진 추가 버튼")
        let alert =  UIAlertController(title: "기프티콘 등록", message: nil, preferredStyle: .actionSheet)

        let library =  UIAlertAction(title: "사진앨범", style: .default) {
            (action) in self.openLibrary()
        }

        let camera =  UIAlertAction(title: "카메라", style: .default) {
            (action) in self.openCamera()
        }

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    func openLibrary(){

//        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: false, completion: nil)
//        } else{
//            print("photoLibrary not available")
//        }

    }

    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
            imagePicker.sourceType = .camera
            present(imagePicker, animated: false, completion: nil)
        } else{
            print("Camera not available")
        }
    }
    
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler : nil)
        
        let defaultAction = UIAlertAction(title: "사진추가", style: .default, handler : {_ in self.plusAction()})
        
        
        alert.addAction(cancelAction)
        if messages == "사진앨범 혹은 카메라로 바코드를 인식해주세요."{
            alert.addAction(defaultAction)
        }
        
        present(alert, animated: true, completion: nil)
    }

    func getText(image: UIImage) {
        let dateYear : String = helper.formatDateToday()
        let endIdx: String.Index = dateYear.index(dateYear.startIndex, offsetBy: 3)
        var dateYears = String(dateYear[...endIdx])
        print("dateYear,, ", dateYears)
        
        
        let koreanOptions = KoreanTextRecognizerOptions()
        let textRecognizer = TextRecognizer.textRecognizer(options: koreanOptions)
        let visionImage = VisionImage(image: image)
        visionImage.orientation = image.imageOrientation
        
        textRecognizer.process(visionImage) { result, error in
            guard error == nil, let result = result else {
                //error handling
                return
            }
            //결과값 출력
            let str = result.text
//                print("resultText: \(str)")
            
//            let deciphered = resultText.split(separator: "\n").reduce(into: [String: AnyObject]()) {
//                let resultText = $1.split(separator: ":")
//                if let first = resultText.first, let value = resultText.last{
//                    $0[String(first)] = value as AnyObject
//                }
//            }
            
            let deciphered = str.split(separator: "\n").reduce(into: [String: AnyObject]()) {
                let str = $1.split(separator: ":")
                if let first = str.first, let value = str.last {
                    let key = String(first)
                    $0[key] = value as AnyObject
                }
            }
            
            let arr = str.components(separatedBy: ["\n",":"])
            print(arr)
            
            for x in 0...arr.count-1 {
//                print("index ,, ", x);
                let x : String = arr[x]
//                print("contains.. ",String(x.contains("뿌링")))
                
                //상품명
                if x.contains("뿌링클") {
                    print("상품명 ",x)
                    let index = IndexPath(row: 1, section: 0)
                    let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                    cell.textfield.text! = x
                } else {
                    let index = IndexPath(row: 1, section: 0)
                    let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                    cell.textfield.text! = ""
                }
                
                //유효기간
                for date in Int(dateYears)!...Int(dateYears)!+10 {
//                    print("for index ",date)
                    if x.contains(String(date)) { // '년월일 /~. 포함시에'
                        if (x.contains("년") ||
                            x.contains("월") ||
                            x.contains("일") ||
                            x.contains("/") ||
                            x.contains(".") ||
                            x.contains("~")) {
                            print("유효기간 ",x)
                            var trimStr = x.components(separatedBy: [" ","/","-",".","~","년","월","일"]).joined()
                            if(trimStr.count == 8){
                                print("8")
                                trimStr.insert("-", at: trimStr.index(trimStr.startIndex, offsetBy: 4))
                                trimStr.insert("-", at: trimStr.index(trimStr.startIndex, offsetBy: 7))
                                let index = IndexPath(row: 3, section: 0)
                                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                                cell.textfield.text! = trimStr
                            } else if (trimStr.count == 16){// 20210908
                                let indexTrim = str.index(str.startIndex, offsetBy: 8)
//                                print("16,,,, ", trimStr.substring(from: indexTrim))  // Swift
                                var trimStr16TO8 = trimStr.substring(from: indexTrim)
                                trimStr16TO8.insert("-", at: trimStr16TO8.index(trimStr16TO8.startIndex, offsetBy: 4))
                                trimStr16TO8.insert("-", at: trimStr16TO8.index(trimStr16TO8.startIndex, offsetBy: 7))
                                
                                let index = IndexPath(row: 3, section: 0)
                                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                                cell.textfield.text! = trimStr16TO8
                            }
                        }
                        
//                        let index = IndexPath(row: 3, section: 0)
//                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
//                        cell.textfield.text! = trimStr
                    }
//                    else {
//                        let index = IndexPath(row: 3, section: 0)
//                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
//                        cell.textfield.text! = ""
//                    }
                } // 유효기간
                
            } // for
            
//            print("###### deciphered ", deciphered)
//            print(deciphered.count, " ##########")
        }
    }
    
//    func readBarcode(uiImage: UIImage){
////        let format = BarcodeFormat.all
//        // vision
//        let image = VisionImage(image: uiImage)
//        image.orientation = imageOrientation(deviceOrientation: UIDevice.current.orientation, cameraPosition: .back) // 아직 작성 안 했음!
//
//        let barcodeScanner = BarcodeScanner.barcodeScanner()
//        barcodeScanner.process(image) { barcodes, error in
//          guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
//            // Error handling
//            let index = IndexPath(row: 2, section: 0)
//            let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
//            cell.textfield.text! = ""
//            cell.textfield.isEnabled = true
//            self.normalAlert(titles: "바코드가 인식 되지 않았습니다", messages: nil)
//            return
//          }
//          // Recognized barcodes
//            for barcode in barcodes {
//              let corners = barcode.cornerPoints
//
//              let displayValue = barcode.displayValue
//              let rawValue = barcode.rawValue
//
//                print("corners ##### ", corners!)
//                print("displayValue ##### ", displayValue!)
//                print("rawValue ##### ", rawValue!)
//
//                let index = IndexPath(row: 2, section: 0)
//                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
//                cell.textfield.text! = displayValue!
//                cell.textfield.isEnabled = false
//
//
//              let valueType = barcode.valueType
//                print("valueType### ", valueType)
//              switch valueType {
//              case .wiFi:
//                let ssid = barcode.wifi?.ssid
//                let password = barcode.wifi?.password
//                let encryptionType = barcode.wifi?.type
//              case .URL:
//                let title = barcode.url!.title
//                let url = barcode.url!.url
//                print("url .. ", url!)
//                print("title .. ", title!)
//              default:
//                print("default")
//                // See API reference for all supported value types
//
//              } //swtich
//            }
//        } // process
//    }
    
    func imageOrientation(
      deviceOrientation: UIDeviceOrientation,
      cameraPosition: AVCaptureDevice.Position
    ) -> UIImage.Orientation {
      switch deviceOrientation {
      case .portrait:
        return cameraPosition == .front ? .leftMirrored : .right
      case .landscapeLeft:
        return cameraPosition == .front ? .downMirrored : .up
      case .portraitUpsideDown:
        return cameraPosition == .front ? .rightMirrored : .left
      case .landscapeRight:
        return cameraPosition == .front ? .upMirrored : .down
      case .faceDown, .faceUp, .unknown:
        return .up
      }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
//        print("textfield.. ", trimStr)
//        print("textField.text?.count ", trimStr.count)
        
        
//        print("index.. ", index)
       
            if textField.text!.count == 5 {
                textField.text!.insert("-", at: textField.text!.index(textField.text!.startIndex, offsetBy: 4))
    //            textField.text.insert("-", at: trimStr.index(trimStr.startIndex, offsetBy: 7))
            }
            else if textField.text!.count == 7 {
                textField.text!.insert("-", at: textField.text!.index(textField.text!.startIndex, offsetBy: 7))
            }
        
        
        checkMaxLength(textField: textField, maxLength: 10)
        
//        guard let text = trimStr.text else { return }
//        textField.text = phoneFormat.addCharacter(at: text)
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.

    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
    
}

extension GiftRegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        print("빈곳 터치 키보드 내리기")
        tableView.keyboardDismissMode = .onDrag
        self.tableView.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //cell.textLabel?.font = UIFont(name: "나눔손글씨 무궁화", size: 20)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell") as! RegisterTableViewCell
        cell.label.text = arr[indexPath.row]
        cell.textfield.text = arrTextField[indexPath.row]
        
        if indexPath.row == 4 {
            let customCell = tableView.dequeueReusableCell(withIdentifier: "RegisterUseTableViewCell") as! RegisterUseTableViewCell
            customCell.segmentControl.addTarget(self, action: #selector(changeSegment), for: UIControl.Event.valueChanged)
            print("customCell.segmentControl.selectedSegmentIndex ",customCell.segmentControl.selectedSegmentIndex)
            return customCell
        }
        
        switch indexPath.row {
        case 0:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 스타벅스", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 1:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 뿌링클 치킨 + 콜라 1.25L", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 2:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 1234-5678-9101 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 3:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 2030-09-08 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
//            cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            break;
        case 4:
//            cell.textfield.isEnabled = true
//            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 미사용", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            break;
        case 5:
            cell.textfield.isEnabled = false
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) \(helper.formatDateToday())", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 6:
            if UserDefaults.standard.string(forKey: "ID") != nil{ // 로그인 o
                cell.textfield.isEnabled = false
            } else{
                cell.textfield.isEnabled = true
            }
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) ghdrlfehd@naver.com(홍길동)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
        default:
            print("default")
            break;
        }
        
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
   }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            var newImage: UIImage? = nil // update 할 이미지
            picker.allowsEditing = false
        
            let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            newImage = possibleImage
        
//            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//                print("수정된 이미지")
//                newImage = possibleImage // 수정된 이미지가 있을 경우
//            } else
            if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    print("원본 이미지")
                    newImage = possibleImage // 원본 이미지가 있을 경우
                }
            
        guard let selectedImage = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
//        readBarcode(uiImage: selectedImage)
        
        let image = VisionImage(image: selectedImage)
        self.getText(image: selectedImage)
        
        let barcodeScanner = BarcodeScanner.barcodeScanner()
        barcodeScanner.process(image) { barcodes, error in
          guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
            // Error handling
            
            //바코드 인식 -> setText
            let index = IndexPath(row: 2, section: 0)
            let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
            cell.textfield.text! = ""
            cell.textfield.isEnabled = true
            
            //이미지 clear
            print("self.nextBool false")
            self.imageView.image = nil
            self.nextBool = false
            
            self.normalAlert(titles: "바코드가 인식 되지 않았습니다", messages: "사진앨범 혹은 카메라로 바코드를 인식해주세요.")
            return
          }
          // Recognized barcodes
            for barcode in barcodes {
                //OCR
              let corners = barcode.cornerPoints

              let displayValue = barcode.displayValue
              let rawValue = barcode.rawValue
                
                print("corners ##### ", corners!)
                print("displayValue ##### ", displayValue!)
                print("rawValue ##### ", rawValue!)
                
                let index = IndexPath(row: 2, section: 0)
                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                cell.textfield.text! = displayValue!
                cell.textfield.isEnabled = false
                
                
              let valueType = barcode.valueType
                print("valueType### ", valueType)
              switch valueType {
              case .wiFi:
                let ssid = barcode.wifi?.ssid
                let password = barcode.wifi?.password
                let encryptionType = barcode.wifi?.type
              case .URL:
                let title = barcode.url!.title
                let url = barcode.url!.url
                print("url .. ", url!)
                print("title .. ", title!)
              default:
                print("default")
                // See API reference for all supported value types
              
              } //swtich
                if(error == nil){
                    print("self.nextBool true")
//                    self.imageView.isHidden = false
                    self.imageView.image = newImage // 받아온 이미지를 update
                    self.nextBool = true
                }
            }
        } // process
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
        
            
//            print("###########",info)
//        print("!@^%#$^!%@&$#*!@(&$#^(& \n", info[UIImagePickerController.InfoKey.imageURL]!)
    }
    
    @objc func changeSegment(_ sender: UISegmentedControl){
        print("sender.isSelected ",sender.selectedSegmentIndex)
        segmentStatus = sender.selectedSegmentIndex
    }
    
    @IBAction func registerAction(_ sender: Any) {
        print("print registerAction")
        for x in 0...6 {
            if x == 4 {
                let index = IndexPath(row: x, section: 0)
                let cell: RegisterUseTableViewCell = self.tableView.cellForRow(at: index) as! RegisterUseTableViewCell
                print("22222222 ", cell.segmentControl.selectedSegmentIndex)
            } else {
                let index = IndexPath(row: x, section: 0)
                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                print("11111 ", cell.textfield.text!)
                if cell.textfield.text == "" {
                    normalAlert(titles: "빈칸없이 작성 해주세요.", messages: nil)
                } // 유효성 확인
            } // else
            
        }// for
        
    }
    
}
