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

class GiftRegisterController : UIViewController{
    
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
        
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.allowsEditing = true // 수정 가능 여부
        self.imagePicker.delegate = self // picker delegate
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
        
        
        //버튼 점선
//        let shapeLayer:CAShapeLayer = CAShapeLayer()
//        let frameSize = plusBtn.frame.size
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
//        plusBtn.layer.addSublayer(shapeLayer)
        

        
        //버튼생성
//        self.scrollView.addSubview(registerButton)ㄴ
//        registerButton.translatesAutoresizingMaskIntoConstraints = false
//
//        registerButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        registerButton.widthAnchor.constraint(equalToConstant: 275).isActive = true
//        registerButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
//        registerButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
//
//        registerButton.setTitle("다음", for: .normal)
//        registerButton.setTitleColor(.black, for: .normal)
//        registerButton.backgroundColor = .orange
        
        //셀 테두리지우기
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //테이블뷰 선택 enable
        tableView.allowsSelection = false
        
        //Specify the xib file to use
        tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterTableViewCell")
        tableView.register(UINib(nibName: "RegisterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterUseTableViewCell")
        
        
        plusAction()
    }
    
    //빈곳 터치 키보드 내리기
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
//          self.view.endEditing(true)
//    }
    
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
    
//    @objc func textFieldDidChange(_ textField: UITextField, index: String?) {
//        checkMaxLength(textField: cellPhoneTextField, maxLength: 13)
//        guard let text = cellPhoneTextField.text else { return }
//        cellPhoneTextField.text = phoneFormat.addCharacter(at: text)
//    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
//
//    func checkMaxLength(textField: UITextField!, maxLength: Int) {
//        if (cellPhoneTextField.text?.count ?? 0 > maxLength) {
//            cellPhoneTextField.deleteBackward()
//        }
//    }
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler : nil)
        let defaultAction = UIAlertAction(title: "사진추가", style: .default, handler : {_ in self.plusAction()})
        
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

    func getText(image: UIImage) {
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
            let resultText = result.text
                print("resultText: \(resultText)")
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
}

extension GiftRegisterController : UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    
    //빈곳 터치 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
          self.view.endEditing(true)
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
//            cell.textField.addTarget(self, action: #selector(self.textFieldDidChange(_:)), for: .editingChanged)
            cell.textfield.tag = indexPath.row
            break;
        case 1:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 뿌링클 치킨 + 콜라 1.25L", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 2:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 1234-5678-9101 ('-'를 제외하고 입력해주세요)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            break;
        case 3:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 2099-99-99 ('-'를 제외하고 입력해주세요)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
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
            
            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                newImage = possibleImage // 수정된 이미지가 있을 경우
            } else if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                newImage = possibleImage // 원본 이미지가 있을 경우
            }
            
        guard let selectedImage = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
        getText(image: selectedImage)
//        readBarcode(uiImage: selectedImage)
        
        let image = VisionImage(image: selectedImage)
        
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