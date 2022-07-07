//
//  GiftRegisterController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/16.
//  기프티콘 등록 화면
// https://ios-development.tistory.com/769   ------> Firebase Storage
// https://fomaios.tistory.com/entry/Swift-Storage%EC%97%90%EC%84%9C-%EC%9D%B4%EB%AF%B8%EC%A7%80-%EC%97%85%EB%A1%9C%EB%93%9C-%EB%B0%8F-%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%ED%95%98%EA%B8%B0

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
import FirebaseStorage
import Alamofire

class GiftRegisterController : UIViewController, UITextFieldDelegate{
    let LOG_TAG : String = "GiftRegisterController"
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var uiView: UIView!
    
    var delegate : GiftDeleteDelegate?
    var delegate2 : GiftDeleteDelegate2?
    var delegate3 : GiftDeleteDelegate3?
    var uploadDelegate : uploadDelegate?
    
    let imagePicker = UIImagePickerController()
    let helper : Helper = Helper()
    let giftDetailController : GiftDetailController = GiftDetailController()
    let localUrl : String = "".getLocalURL()
    let deviceID : String? = UserDefaults.standard.string(forKey: "device_id")
    
    var arr = ["교환처", "상품명", "바코드 번호", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var arrTextField = ["", "", "", "", "", "", ""]
    var segmentStatus : Int = 0
    var registerButton = UIButton()
    var s = 0
    var registerDic : Dictionary = [Int:Any]()
    
    var result : Bool = false
    
    
    var imageBool : Bool = false
    var emptyBool : Bool = false
    var regularStatusBool : Bool = false
    var regularBool : Bool = false

    
    var imgLocalUrl : String? = nil
    var newImage: UIImage? = nil // update 할 이미지
    var barcodeImage: UIImage? = nil
    
    var backBtn : String? = nil
    
    
    let toolBar = UIToolbar()
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
    
    var reviseDic : Dictionary<String, Any>? = nil
    var reviseImage : UIImage? = nil
    
    var detailDelegate : detailDelegate?
    
    let dismissBtn = UIButton()
    @IBOutlet weak var uiViewHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopAnchor: NSLayoutConstraint!//0
    @IBOutlet weak var tableViewTopAnchor: NSLayoutConstraint!//20
    @IBOutlet weak var bottomBtnTopAnchor: NSLayoutConstraint!//20
    
    override func viewDidLoad() {
        super.viewDidLoad();
        self.imagePicker.delegate = self // picker delegate
        self.imagePicker.sourceType = .photoLibrary // 앨범에서 가져옴
        self.imagePicker.allowsEditing = false // 수정 가능 여부
        self.scrollView.delegate = self

        print("reviseDic ", reviseDic)
        
        if reviseImage != nil{
            regularBool = true // 기프티콘 수정 default값
            regularStatusBool = true // 기프티콘 수정 default값
            
            revisSetup()
            
            DispatchQueue.global(qos: .userInteractive).async {
                DispatchQueue.main.async {
                    self.imageView.image = self.reviseImage
                }
            }
            
            registerBtn.setTitle("수정", for: .normal)
        }else {
            plusAction()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //btn layout setting
        setupLayout()
        
        //네비게이션바 setting
        setupNavigationBar()
        
        //툴바 setting
//        setupToolBar()
        
        //등록일, 등록자 default setting
        deafultSetting()
        
        //테이블뷰 setup
        setupTableView()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        imageView.addGestureRecognizer(tapGR)
                        imageView.isUserInteractionEnabled = true
        
        print("deviceID : ", deviceID!)
        
    }
    
    func revisSetup(){
        dismissBtn.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissBtn.contentVerticalAlignment = .fill
        dismissBtn.contentHorizontalAlignment = .fill
        dismissBtn.tintColor = .systemBlue
        dismissBtn.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.scrollView.addSubview(dismissBtn)
        
        dismissBtn.translatesAutoresizingMaskIntoConstraints = false
        dismissBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        dismissBtn.widthAnchor.constraint(equalToConstant: 22).isActive = true
        
        dismissBtn.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        dismissBtn.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 30).isActive = true
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        uiViewHeight.constant = 1000
        
        tableViewTopAnchor.constant = 20
        bottomBtnTopAnchor.constant = 20
        
        imageViewTopAnchor.isActive = false
        imageViewTopAnchor = imageView.topAnchor.constraint(equalTo: dismissBtn.bottomAnchor, constant: 20)
        imageViewTopAnchor.isActive = true
    }
    
    @objc func backButtonAction() {
        print("Button tapped")
        dismiss(animated: true, completion: nil)
    }
    
    func setupTableView(){
        //셀 테두리지우기
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //테이블뷰 선택 enable
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        
        //Specify the xib file to use
        tableView.register(UINib(nibName: "RegisterTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterTableViewCell")
        tableView.register(UINib(nibName: "RegisterUseTableViewCell", bundle: nil), forCellReuseIdentifier: "RegisterUseTableViewCell")
    }
    
    func setupToolBar(){
        toolBar.sizeToFit()
        
//        let backBtn = UIButton.init(type: .custom)
//        backBtn.setTitle("이전", for: .normal)
//        backBtn.setTitleColor(.systemBlue, for: .normal)
//        backBtn.addTarget(self, action: #selector(self.backBtnAction(_:)), for: .touchUpInside)
        
        let nextBtn = UIButton.init(type: .custom)
        nextBtn.setTitle("완료", for: .normal)
        nextBtn.setTitleColor(.systemBlue, for: .normal)
        nextBtn.addTarget(self, action: #selector(self.nextBtnAction(_:)), for: .touchUpInside)
        
//        let backButton = UIBarButtonItem.init(customView: backBtn)
        let nextButton = UIBarButtonItem.init(customView: nextBtn)
        
        toolBar.items = [nextButton]
//        toolBar.barStyle = .black
        toolBar.barTintColor = UIColor.white
        toolBar.tintColor = .white
    }
    
    func deafultSetting(){
        // 등록일 Default Setting
        arrTextField.insert(helper.formatDateToday(), at: 5)
        
        // 등록자 Default Setting
        if(UserDefaults.standard.string(forKey: "ID") != nil){ //로그인 O
            arrTextField.insert("\(UserDefaults.standard.string(forKey: "ID")!)"+"(\(UserDefaults.standard.string(forKey: "name")!))", at: 6)
        }
    }
    
    func setupLayout(){
        registerBtn.layer.cornerRadius = 5
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 등록 화면"
        
        
        let rightBarButton = UIBarButtonItem.init(image: UIImage(systemName: "camera"),  style: .plain, target: self, action: #selector(self.plusAction)) //Class.MethodName
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func backBtnAction(_ textField: UITextField){
        print("backBtnAction")
        textField.becomeFirstResponder();
    }

    @objc func nextBtnAction(_ textField: UITextField){
        self.tableView.endEditing(true)
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
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

        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
//        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func imageNil() {
        self.imageView.image = nil
    }
    
    func openLibrary(){

//        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: false, completion: nil)
//        } else{
//            print("photoLibrary not available")
//        }

    }

//    func openCamera(){
//        if(UIImagePickerController .isSourceTypeAvailable(.photoLibrary)){
//            imagePicker.sourceType = .camera
//            present(imagePicker, animated: false, completion: nil)
//        } else{
//            print("Camera not available")
//        }
//    }
    
    
    func normalAlert(titles:String, messages:String?) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        if titles == "바코드가 인식 되지 않는 이미지 입니다." {
            let cancelAction = UIAlertAction(title: "이 이미지 사용안함", style: .cancel, handler : {_ in self.imageNil()})
            
            let defaultAction = UIAlertAction(title: "이 이미지 사용", style: .default, handler : nil)
            let defaultAction1 = UIAlertAction(title: "다른 이미지 사용", style: .default, handler : {_ in self.plusAction()})
            alert.addAction(cancelAction)
            alert.addAction(defaultAction)
            alert.addAction(defaultAction1)
        }else if titles == "빈칸없이 작성 해주세요." {
            let cancelAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(cancelAction)
        }else if messages == "이미 등록된 기프티콘이거나 선물한 기프티콘입니다." || messages == "기프티콘 이미지를 등록해주세요."{
            let cancelAction = UIAlertAction(title: "확인", style: .default,  handler : {_ in self.plusAction()})
            alert.addAction(cancelAction)
        }else if messages == "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?"{
            let okAction = UIAlertAction(title: "확인", style: .default,  handler : {_ in self.segmentChange()})
            let cancelAction = UIAlertAction(title: "취소", style: .cancel,  handler : nil)
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        }else { // 유효기간 formatting
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
        }
        
        
        present(alert, animated: true, completion: nil)
    }
    
    func normalAlert(titles:String, messages:String?,_ textfield : UITextField) -> Void{
        let alert = UIAlertController(title: titles, message: messages, preferredStyle: UIAlertController.Style.alert)
        if messages == "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?"{
            let okAction = UIAlertAction(title: "확인", style: .default,  handler : {_ in self.segmentChange()})
            let cancelAction = UIAlertAction(title: "취소", style: .cancel,  handler : {_ in self.textFieldClean(textfield)})
            alert.addAction(okAction)
            alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        }
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
        
        textRecognizer.process(visionImage) { [self] result, error in
            guard error == nil, let result = result else {
                //error handling
                return
            }
            //결과값 출력
            let str = result.text
            
            let deciphered = str.split(separator: "\n").reduce(into: [String: AnyObject]()) {
                let str = $1.split(separator: ":")
                if let first = str.first, let value = str.last {
                    let key = String(first)
                    $0[key] = value as AnyObject
                }
            }
            
            let arr = str.components(separatedBy: ["\n",":"])
            print(arr)
            
            //교환처
            var exchangeArr : [String] = self.exchange()
            self.exchangeContain(arr1: arr, arr2: exchangeArr)
            
            for x in 0..<arr.count {
//                print("index ,, ", x);
                let x : String = arr[x]
                
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
                                
                                let regularExpression = trimStr.validateDate(trimStr.replacingOccurrences(of: "-", with: ""))
                                print("regularExpression ",regularExpression)
                                if regularExpression != ""{
                                    self.normalAlert(titles: "알림", messages: regularExpression)
                                    self.regularBool = false
                                }else { // 날짜 정규식은 이상 없음 -> 이후 오늘날짜와 유효기간을 비교
                                    self.regularBool = true
                                    print("text ---------> 388line -----> ", trimStr)
                                    
                                    let resultDDayBarcode1 : Int = self.giftDetailController.calculateDays(availableDate: trimStr)
                                    if resultDDayBarcode1 == 0 {
                                        print("resultDDayBarcode1")
                                        self.regularStatusBool = true
                                    }else if resultDDayBarcode1 > 0 {
                                        print("resultDDayBarcode1 > 0")
                                        self.normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?", cell.textfield)
                                        regularStatusBool = false
                                    }else if resultDDayBarcode1 < 0 {
                                        print("resultDDayBarcode1 < 0")
                                        self.regularStatusBool = true
                                    }
                                }
                                
                            } else if (trimStr.count == 16){// 20210908
                                let indexTrim = str.index(str.startIndex, offsetBy: 8)
//                                print("16,,,, ", trimStr.substring(from: indexTrim))  // Swift
                                var trimStr16TO8 = trimStr.substring(from: indexTrim)
                                trimStr16TO8.insert("-", at: trimStr16TO8.index(trimStr16TO8.startIndex, offsetBy: 4))
                                trimStr16TO8.insert("-", at: trimStr16TO8.index(trimStr16TO8.startIndex, offsetBy: 7))
                                
                                let index = IndexPath(row: 3, section: 0)
                                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                                cell.textfield.text! = trimStr16TO8
                                
                                    let regularExpression = trimStr16TO8.validateDate(trimStr16TO8.replacingOccurrences(of: "-", with: ""))
                                    print("regularExpression ",regularExpression)
                                    if regularExpression != ""{
                                        self.normalAlert(titles: "알림", messages: regularExpression)
                                        self.regularBool = false
                                    }else { // 날짜 정규식은 이상 없음 -> 이후 오늘날짜와 유효기간을 비교
                                        self.regularBool = true
                                        print("text ---------> 388line -----> ", trimStr16TO8)
                                        
                                        let resultDDayBarcode2 : Int = self.giftDetailController.calculateDays(availableDate: trimStr16TO8)
                                        if resultDDayBarcode2 == 0 {
                                            print("resultDDayBarcode2")
                                            self.regularStatusBool = true
                                        }else if resultDDayBarcode2 > 0 {
                                            self.normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?", cell.textfield)
                                            print("resultDDayBarcode2 > 0")
                                            regularStatusBool = false
                                        }else if resultDDayBarcode2 < 0 {
                                            print("resultDDayBarcode2 < 0")
                                            self.regularStatusBool = true
                                        }
                                    }
                            }
                        }
                        
                    }
                } // 유효기간
                
            } // for
            
        }
    }
    
    func exchange() -> Array<String>{
        var exchangeArr = [String]()
        
        //편의점
        exchangeArr.append("GS25")
        exchangeArr.append("gs25")
        exchangeArr.append("CU")
        exchangeArr.append("cu")
        exchangeArr.append("Cu")
        exchangeArr.append("세븐일레븐")
        exchangeArr.append("이마트24")
        exchangeArr.append("미니스톱")
        exchangeArr.append("씨스페잇")
        
        //카페
        exchangeArr.append("스타벅스")
        exchangeArr.append("투썸플레이스")
        exchangeArr.append("파리바게트")
        exchangeArr.append("파리바게뜨")
        exchangeArr.append("뚜레쥬르")
        exchangeArr.append("던킨")
        exchangeArr.append("크리스피크림")
        exchangeArr.append("디저트39")
        exchangeArr.append("아티제")
        exchangeArr.append("한스케익")
        exchangeArr.append("파리크라상")
        exchangeArr.append("카페노티드")
        exchangeArr.append("성심당")
        exchangeArr.append("앤티앤스프레즐")
        exchangeArr.append("와플대학")
        exchangeArr.append("빌리엔젤(교환권)")
        exchangeArr.append("홍루이젠")
        exchangeArr.append("빚은")
        exchangeArr.append("김영모과자점")
        exchangeArr.append("떡보의하루")
        exchangeArr.append("코코호두")
        exchangeArr.append("나폴레웅제과점(교환권)")
        exchangeArr.append("롤링핀")
        exchangeArr.append("망원동티라미수")
        exchangeArr.append("베즐리")
        exchangeArr.append("도레도레")
        exchangeArr.append("자연드림")
        exchangeArr.append("시나본")
        exchangeArr.append("패션5")
        exchangeArr.append("밀도")
        exchangeArr.append("곤트란쉐리에")
        exchangeArr.append("나폴레옹과자점")
        exchangeArr.append("라라브레드")
        exchangeArr.append("스트릿츄러스")
        exchangeArr.append("브레댄코")
        exchangeArr.append("지유가오카")
        exchangeArr.append("브리오슈도레")
        exchangeArr.append("마리웨일237")
        exchangeArr.append("케이크를부탁해")
        exchangeArr.append("노아베이커리")
        exchangeArr.append("베이크팡")
        exchangeArr.append("몽 블랑제")
        exchangeArr.append("리치몬드과자점")
        exchangeArr.append("정도너츠")
        exchangeArr.append("빵장수단팥빵")
        exchangeArr.append("호밀호두")
        exchangeArr.append("아자부카페")
        exchangeArr.append("쁘띠렌")
        exchangeArr.append("도쿄팡야")
        exchangeArr.append("케르반 베이커리")
        exchangeArr.append("줄리앙와플 마망갸또")
        
        //치킨
        exchangeArr.append("교촌치킨")
        exchangeArr.append("bhc")
        exchangeArr.append("Bhc")
        exchangeArr.append("BHC")
        exchangeArr.append("BHc")
        
        //아이스크림
        exchangeArr.append("베스킨라빈스")
        exchangeArr.append("베스킨 라빈스")
        
        
        return exchangeArr
    }
    
    func exchangeContain(arr1 : Array<String>, arr2 : Array<String>) -> Void{
        //arr1 recognizer text
        //arr2 exchagne
        
        let index = IndexPath(row: 0, section: 0)
        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
        
        for x in 0..<arr1.count {
                print("arr1,, ", arr1[x]);
            let x : String = arr1[x]
            for a in 0..<arr2.count {
                print("index 2,, ", arr2[a]);
                if x.contains(arr2[a]) {
                    cell.textfield.text! = arr2[a]
                    return
                } else{
                    cell.textfield.text! = ""
                }
            }
        }
    }
    
    
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
    
    @objc func textFieldDidChange0(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 10)
        guard let text = textField.text else { return }
        textField.text = text
    }
    
    @objc func textFieldDidChange1(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 30)
        guard let text = textField.text else { return }
        textField.text = text
    }
    
    @objc func textFieldDidChange2(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 24)
        guard let text = textField.text else { return }
        textField.text = text
    }
    
    @objc func textFieldDidChange3(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 8)
        guard let text = textField.text else { return }
        textField.text = text
    }   // phoneFormat.addCharacter에 텍스트를 넣어주면 init시 넣은 character가 구분자로 들어간 값이 반환됩니다.
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 10)
        guard let text = textField.text else { return }
        
        if text.count != 0 {
            if !isValidPhone(phone: text.replacingOccurrences(of: "-", with: "")){ //숫자 정규식
                normalAlert(titles: "알림", messages: "유효기간을 숫자로만 입력해주세요 ('-'를 제외하고 입력)")
                regularBool = false
            }else {
                switch (text.count) {
                case 1..<8:
                    normalAlert(titles: "알림", messages: "유효기간을 다시 확인해주세요.\n 2030-09-08 ('-'를 제외하고 입력)")
                    textField.becomeFirstResponder()
                    regularBool = false
                    break;
                    
                case 8:// 20210515 날짜 정규식 추가 예정
                    textField.text = text.replacingOccurrences(of: "-", with: "").substring(from: 0, to: 3)+"-"+text.replacingOccurrences(of: "-", with: "").substring(from: 4, to: 5)+"-"+text.replacingOccurrences(of: "-", with: "").substring(from: 6, to: 7)
                    
                    let regularExpression = text.validateDate(text.replacingOccurrences(of: "-", with: ""))
                    print("regularExpression ",regularExpression)
                    if regularExpression != ""{
                        normalAlert(titles: "알림", messages: regularExpression)
                        regularBool = false
                    }else { // 날짜 정규식은 이상 없음 -> 이후 오늘날짜와 유효기간을 비교
                        regularBool = true
                        print("text ---------> 545line -----> ", textField.text! )
                        
                        let regularExpression = text.validateDate(text.replacingOccurrences(of: "-", with: ""))
                        print("regularExpression ",regularExpression)
                        if regularExpression != ""{
                            normalAlert(titles: "알림", messages: regularExpression)
                            regularBool = false
                        }else { // 날짜 정규식은 이상 없음 -> 이후 오늘날짜와 유효기간을 비교
                            regularBool = true
                            print("text ---------> 545line -----> ", textField.text! )
                            
                            let resultDDay : Int = giftDetailController.calculateDays(availableDate: textField.text!)
                            if resultDDay == 0 {
                                print("resultDDay")
                                regularStatusBool = true
                            }else if resultDDay > 0 {
                                normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?", textField)
                                regularStatusBool = false
                            }else if resultDDay < 0 {
                                print("resultDDay < 0")
                                regularStatusBool = true
                            }
                            
                        }
                        
                    }
                    
                    break;
                    
                default:
                    print("default")
                    break;
                }
            }
        }
        
        
//            normalAlert(titles: "알림", messages: "유효기간을 다시 확인해주세요.")
    }
    
    @objc func segmentChange(){
        print("segmentChange")
        
        let index = IndexPath(row: 4, section: 0)
        let cell: RegisterUseTableViewCell = self.tableView.cellForRow(at: index) as! RegisterUseTableViewCell
        cell.segmentControl.selectedSegmentIndex = 1
        segmentStatus = 1
        
        tableView.refreshControl?.sendActions(for: .valueChanged)
    }
    
    @objc func textFieldClean(_ textField: UITextField){
        guard let text = textField.text else { return }
        textField.text = ""
    }
    
    @objc func textFieldDidBigin(_ textField: UITextField) {
        guard let text = textField.text else { return }
        print("textFieldDidBigin!!!  \(#line)")
        textField.text = text.replacingOccurrences(of: "-", with: "")
    }
    
    func isValidPhone(phone: String?) -> Bool {
            guard phone != nil else { return false }

            let phoneRegEx = "[0-9]{1,8}"
            let pred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
            return pred.evaluate(with: phone)
        }
    
    @objc func textFieldDidChange6(_ textField: UITextField) {
        checkMaxLength(textField: textField, maxLength: 30)
        guard let text = textField.text else { return }
        textField.text = text
    }

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
        
        if reviseDic != nil{
            arr[5] = "수정날짜"
            let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell") as! RegisterTableViewCell
            cell.label.text = arr[indexPath.row]
            cell.textfield.text = arrTextField[indexPath.row]
//            cell.textfield.inputAccessoryView = toolBar
            
            if indexPath.row == 4 {
                let customCell = tableView.dequeueReusableCell(withIdentifier: "RegisterUseTableViewCell") as! RegisterUseTableViewCell
                customCell.segmentControl.addTarget(self, action: #selector(changeSegment), for: UIControl.Event.valueChanged)
                customCell.segmentControl.selectedSegmentIndex = reviseDic!["use_yn"] as! Int
                print("customCell.segmentControl.selectedSegmentIndex ",customCell.segmentControl.selectedSegmentIndex)
                return customCell
            }
            
            switch indexPath.row {
            case 0:
                cell.textfield.isEnabled = true
                cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 스타벅스", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
                cell.textfield.text = reviseDic!["brand"] as! String
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange0(_:)), for: .editingChanged)
                cell.textfield.tag = indexPath.row
                break;
            case 1:
                cell.textfield.isEnabled = true
                cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 뿌링클 치킨 + 콜라 1.25L", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
                cell.textfield.text = reviseDic!["product_name"] as! String
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange1(_:)), for: .editingChanged)
                cell.textfield.tag = indexPath.row
                break;
            case 2:
                cell.textfield.isEnabled = true
                cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 1234-5678-9101 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
                cell.textfield.text = reviseDic!["barcode_number"] as! String
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange2(_:)), for: .editingChanged)
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidBigin(_:)), for: .editingDidEnd) // '-' 제거
                cell.textfield.keyboardType = .numberPad
                cell.textfield.tag = indexPath.row
                break;
            case 3:
                cell.textfield.isEnabled = true
                cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 2030-09-08 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
                cell.textfield.tag = indexPath.row
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange3(_:)), for: .editingChanged)
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingDidEnd)
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidBigin(_:)), for: .editingDidBegin)
                cell.textfield.text = reviseDic!["expiration_period"] as! String
                cell.textfield.keyboardType = .numberPad
                cell.textfield.delegate = self
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
                cell.textfield.text = reviseDic!["registrant"] as! String
                cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange6(_:)), for: .editingChanged)
            default:
                print("default")
                break;
            }
            
                return cell
            }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterTableViewCell") as! RegisterTableViewCell
        cell.label.text = arr[indexPath.row]
        cell.textfield.text = arrTextField[indexPath.row]
//        cell.textfield.inputAccessoryView = accessory
        
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
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange0(_:)), for: .editingChanged)
            cell.textfield.tag = indexPath.row
            break;
        case 1:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 뿌링클 치킨 + 콜라 1.25L", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange1(_:)), for: .editingChanged)
            cell.textfield.tag = indexPath.row
            break;
        case 2:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 1234-5678-9101 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange2(_:)), for: .editingChanged)
            cell.textfield.keyboardType = .numberPad
            cell.textfield.tag = indexPath.row
            break;
        case 3:
            cell.textfield.isEnabled = true
            cell.textfield.attributedPlaceholder = NSAttributedString(string: "ex) 2030-09-08 ('-'를 제외하고 입력)", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
            cell.textfield.tag = indexPath.row
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange3(_:)), for: .editingChanged)
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingDidEnd)
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidBigin(_:)), for: .editingDidBegin)
            cell.textfield.keyboardType = .numberPad
            cell.textfield.delegate = self
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
            cell.textfield.addTarget(self, action: #selector(self.textFieldDidChange6(_:)), for: .editingChanged)
        default:
            print("default")
            break;
        }
        
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
   }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            registerDic[8] = ""
//            picker.allowsEditing = false
        
//            if let possibleImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//                print("수정된 이미지")
//                newImage = possibleImage // 수정된 이미지가 있을 경우
//            } else
            if let possibleImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    print("원본 이미지 \(info)")
                    newImage = possibleImage // 원본 이미지가 있을 경우
                barcodeImage = possibleImage
            }
        
        print("DB 중복값 확인할 것1 ", info[UIImagePickerController.InfoKey.referenceURL]!) // DB랑 중복값 확인해야함
              
        guard let selectedImage = info[.originalImage] as? UIImage else {
                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
                }
        
//        guard let notOriginImage = info[.editedImage] as? UIImage else {
//                    fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//                }
        
//        imgLocalUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL
        
        if let referenceUrl = info[UIImagePickerController.InfoKey.referenceURL] as? NSURL {
               //access the file name
            imgLocalUrl = referenceUrl.absoluteString
            
            let image = VisionImage(image: self.barcodeImage!)
            self.getText(image: self.barcodeImage!)
            
            let barcodeScanner = BarcodeScanner.barcodeScanner()
            barcodeScanner.process(image) { barcodes, error in
              guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                // Error handling
                return
              }
              // Recognized barcodes
                for barcode in barcodes {
                    //OCR
                    let displayValue = barcode.displayValue
                    
                    self.registerDic[8] = displayValue
                    if(error == nil){
    //                    self.imageView.isHidden = false
    //                    self.imageView.image = newImage // 받아온 이미지를 update
                    }
                }
                self.registerDic[7] = self.imgLocalUrl
                print("imgLocalUrl ", self.registerDic[7]!)
                print("barcodeNumber ", self.registerDic[8]!)
                if self.registerDic[8] as! String == nil || self.registerDic[8] as! String == "" {
                    self.registerDic[8] = ""
                }
                self.requestPostOverlap(requestUrl: "/overlap/photo", url : self.imgLocalUrl, barcode: self.registerDic[8] as! String)
            } // process
       }
        picker.dismiss(animated: true, completion: nil) // picker를 닫아줌
    }
    
    @objc func changeSegment(_ sender: UISegmentedControl){
        print("sender.isSelected ",sender.selectedSegmentIndex)
        
        let index = IndexPath(row: 3, section: 0)
        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
        var txtField3 = cell.textfield.text
        
        self.tableView.endEditing(true)
        
        if txtField3?.count == 10{
            if sender.selectedSegmentIndex == 0{
                let regularExpression = txtField3!.validateDate(txtField3!.replacingOccurrences(of: "-", with: ""))
                print("regularExpression ",regularExpression)
                if regularExpression != ""{
                    normalAlert(titles: "알림", messages: regularExpression)
                    regularBool = false
                }else { // 날짜 정규식은 이상 없음 -> 이후 오늘날짜와 유효기간을 비교
                    regularBool = true
                    
                    let resultDDay : Int = giftDetailController.calculateDays(availableDate: txtField3!)
                    if resultDDay == 0 {
                        print("resultDDay")
                        regularStatusBool = true
                    }else if resultDDay > 0 {
                        print("resultDDay > 0")
                        normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다.\n 그래도 등록하시겠습니까?")
                        regularStatusBool = false
                    }else if resultDDay < 0 {
                        print("resultDDay < 0")
                        regularStatusBool = true
                    }
                    
                }
            }
        }
        
        segmentStatus = sender.selectedSegmentIndex
    }
    
    @IBAction func registerAction(_ sender: Any) {
        registerBtn.isEnabled = false
        self.tableView.endEditing(true)
        if registerBtn.titleLabel?.text! == "수정"{ // 기프티콘 수정
            
            for x in 0...6 {
                    switch x {
                    case 0...3:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                        if cell.textfield.text != ""{
                            registerDic[x] = cell.textfield.text!
                        }
                        break
                    case 4:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterUseTableViewCell = self.tableView.cellForRow(at: index) as! RegisterUseTableViewCell
                        registerDic[x] = cell.segmentControl.selectedSegmentIndex
                        break
                    case 5...6:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                        if cell.textfield.text != ""{
                            registerDic[x] = cell.textfield.text!
                        }
                        break
                    default:
                        print("default")
                        break
                    }
            }// for

            if  registerDic[0] != nil &&
                registerDic[1] != nil &&
                registerDic[2] != nil &&
                registerDic[3] != nil &&
                registerDic[5] != nil &&
                registerDic[6] != nil {
                print("emptybool ---------> true")
                emptyBool = true
            }

//            print("registerDic.. 1 ", registerDic)
//            print("self.imageView.image ", self.imageView.image)
            if self.imageView.image == nil{ // 이미지가 없을경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "기프티콘 이미지를 등록해주세요.")
            }else if !emptyBool { // 하나라도 빈칸일 경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "빈칸없이 작성 해주세요.")
            }else if !regularBool { // 유효기간이 유효하지 않을경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "유효기간을 확인해주세요.")
            }else if !regularStatusBool && segmentStatus == 0{
                registerBtn.isEnabled = true
                print("regularStatusBool ", regularStatusBool)
                print("segmentStatus ", segmentStatus)
                normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다. \n 쿠폰상태를 확인해주세요.")
            }else { // firebase 서버 request
                print("수정 registerDic.. ", registerDic)

                if UserDefaults.standard.string(forKey: "ID") != nil{
                    var param = [
                        "user_id" : UserDefaults.standard.string(forKey: "ID")!,
        //                "img_url" : "gs://save-gift-e3710.appspot.com/\(UserDefaults.standard.string(forKey: "imageName")!)", //FireBase URL로 등록
                        "brand" : registerDic[0]!,
                        "barcode_number" : registerDic[2]!,
                        "expiration_period" : registerDic[3]!,
                        "registration_date" : registerDic[5]!,
                        "use_yn" : registerDic[4]!,
                        "device_id" : deviceID!,
                        "registrant" : registerDic[6]!,
                        "product_name" : registerDic[1]!,
                        "seq" : reviseDic!["seq"]!,
                        "index" : "reviseLogin"
                    ] as [String : Any] // JSON 객체로 전송할 딕셔너리
                    print("회원 수정 로직 param => " ,param)
                    requestPost(requestUrl: "/gift/revise", param: param)
                    //회원 수정 로직
                }else {
                    var param = [
                        "brand" : registerDic[0]!,
                        "barcode_number" : registerDic[2]!,
                        "expiration_period" : registerDic[3]!,
                        "registration_date" : registerDic[5]!,
                        "use_yn" : registerDic[4]!,
                        "device_id" : deviceID!,
                        "registrant" : registerDic[6]!,
                        "product_name" : registerDic[1]!,
                        "seq" : reviseDic!["seq"]!,
                        "index" : "reviseBLogin"
                    ] as [String : Any] // JSON 객체로 전송할 딕셔너리
                    print("비회원 수정 로직 param => " ,param)
                    requestPost(requestUrl: "/gift/revise", param: param)
                    //비회원 수정 로직
                }
            }
        }else { // 기프티콘 등록
            for x in 0...6 {
                    switch x {
                    case 0...3:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                        if cell.textfield.text != ""{
                            registerDic[x] = cell.textfield.text!
                        }
                        break
                    case 4:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterUseTableViewCell = self.tableView.cellForRow(at: index) as! RegisterUseTableViewCell
                        registerDic[x] = cell.segmentControl.selectedSegmentIndex
                        break
                    case 5...6:
                        let index = IndexPath(row: x, section: 0)
                        let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                        if cell.textfield.text != ""{
                            registerDic[x] = cell.textfield.text!
                        }
                        break
                    default:
                        print("default")
                        break
                    }
    //            }else {
    ////                    cell.textfield.becomeFirstResponder()
    //            }
            }// for

            if  registerDic[0] != nil &&
                registerDic[1] != nil &&
                registerDic[2] != nil &&
                registerDic[3] != nil &&
                registerDic[5] != nil &&
                registerDic[6] != nil {
                print("emptybool ---------> true")
                emptyBool = true
            }

//            print("registerDic.. 1 ", registerDic)
//            print("self.imageView.image ", self.imageView.image)
            if self.imageView.image == nil{ // 이미지가 없을경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "기프티콘 이미지를 등록해주세요.")
            }else if !emptyBool { // 하나라도 빈칸일 경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "빈칸없이 작성 해주세요.")
            }else if !regularBool { // 유효기간이 유효하지 않을경우
                registerBtn.isEnabled = true
                normalAlert(titles: "알림", messages: "유효기간을 확인해주세요.")
            }else if !regularStatusBool && segmentStatus == 0{
                registerBtn.isEnabled = true
                print("regularStatusBool ", regularStatusBool)
                print("segmentStatus ", segmentStatus)
                normalAlert(titles: "알림", messages: "유효기간이 지난 기프티콘 입니다. \n 쿠폰상태를 확인해주세요.")
            }else { // 서버 request
                print("등록 registerDic.. ", registerDic)

                if UserDefaults.standard.string(forKey: "ID") != nil{
                    var param = [
                        "user_id" : UserDefaults.standard.string(forKey: "ID")!,
        //                "img_url" : "gs://save-gift-e3710.appspot.com/\(UserDefaults.standard.string(forKey: "imageName")!)", //FireBase URL로 등록
                        "brand" : registerDic[0]!,
                        "barcode_number" : registerDic[2]!,
                        "expiration_period" : registerDic[3]!,
                        "registration_date" : registerDic[5]!,
                        "use_yn" : registerDic[4]!,
                        "device_id" : deviceID!,
                        "registrant" : registerDic[6]!,
                        "product_name" : registerDic[1]!,
                        "img_local_url" : registerDic[7]!,
                        "file_name" : self.deviceID! + "_" + self.helper.formatDateTime()
                    ] as [String : Any] // JSON 객체로 전송할 딕셔너리
                    uploadDiary(date: helper.formatDateToday(), self.newImage!, requestUrl: "/register/image", param: param)
                }else {
                    var param = [
                        "brand" : registerDic[0]!,
                        "barcode_number" : registerDic[2]!,
                        "expiration_period" : registerDic[3]!,
                        "registration_date" : registerDic[5]!,
                        "use_yn" : registerDic[4]!,
                        "device_id" : deviceID!,
                        "registrant" : registerDic[6]!,
                        "product_name" : registerDic[1]!,
                        "img_local_url" : registerDic[7]!,
                        "file_name" : self.deviceID! + "_" + self.helper.formatDateTime()
                    ] as [String : Any] // JSON 객체로 전송할 딕셔너리
                    uploadDiary(date: helper.formatDateToday(), self.newImage!, requestUrl: "/register/image", param: param)
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.helper.hideLoading()
        }
    }
    
    func requestPost(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("\(#file) \(#function) \(#line) param ..... ", param)
        let paramData = try! JSONSerialization.data(withJSONObject: param)
        // URL 객체 정의
        
                let url = URL(string: localUrl+requestUrl)

                // URLRequest 객체를 정의
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = paramData

                // HTTP 메시지 헤더
//                request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
//                request.addValue("application/json", forHTTPHeaderField: "Accept")
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

                    print("\(self.LOG_TAG) \(#line) responseString", responseString!)
                    
                    DispatchQueue.main.async{
                        if responseString! == "1"{ // 성공시
                            print("\(self.LOG_TAG) \(#line) responseString 1")
                            
                            self.detailDelegate?.refreshTableView(dicT: param)
//                            self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else { // 실패시
                            print("\(self.LOG_TAG) \(#line) else")
                            
                            self.normalAlert(titles: "알림", messages: "기프티콘 수정 실패")
                        }
                    }
                    
                }
                // POST 전송
                task.resume()
    }
    
    func requestPostOverlap(requestUrl : String!, url : String!, barcode : String!) -> Void{

//        registerDic[0] -> 교환처
//        registerDic[1] -> 상품명
//        registerDic[2] -> 바코드 번호
//        registerDic[3] -> 유효기간
//        registerDic[4] -> 쿠폰 상태
//        registerDic[5] -> 등록일
//        registerDic[6] -> 등록자

        let param = [
            "img_local_url" : url,
            "device_id" : deviceID!,
            "barcode_number" : barcode
        ] as [String : Any] // JSON 객체로 전송할 딕셔너리
        
        let paramData = try! JSONSerialization.data(withJSONObject: param)
        // URL 객체 정의r
                let url = URL(string: localUrl+requestUrl)

                // URLRequest 객체를 정의
                var request = URLRequest(url: url!)
                request.httpMethod = "POST"
                request.httpBody = paramData

                // HTTP 메시지 헤더
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

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

                if(responseString != "0"){
                        DispatchQueue.main.async{
                            self.imageView.image = nil
                            self.normalAlert(titles: "알림", messages: "이미 등록된 기프티콘이거나 선물한 기프티콘입니다.")
                            
                            for x in 0...3 {
                                let index = IndexPath(row: x, section: 0)
                                let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                                cell.textfield.text! = ""
                                cell.textfield.isEnabled = true
                            }
                            
                        }
                }else {
                    DispatchQueue.main.async{
                        self.imageView.image = self.newImage // 받아온 이미지를 update
                        
                        let image = VisionImage(image: self.barcodeImage!)
                        self.getText(image: self.barcodeImage!)
                        
                        let barcodeScanner = BarcodeScanner.barcodeScanner()
                        barcodeScanner.process(image) { barcodes, error in
                          guard error == nil, let barcodes = barcodes, !barcodes.isEmpty else {
                            // Error handling
                            
                            //바코드 인식 -> setText
                            let index = IndexPath(row: 2, section: 0)
                            let cell: RegisterTableViewCell = self.tableView.cellForRow(at: index) as! RegisterTableViewCell
                            cell.textfield.text! = ""
                            cell.textfield.isEnabled = true
                            
                //            self.imageView.image = nil
                            
                            self.normalAlert(titles: "바코드가 인식 되지 않는 이미지 입니다.", messages: "화질이 좋지 않은 이미지는 바코드가 인식 하지 않을수도 있습니다.\n 그래도 등록 하시겠습니까?")
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
                //                    self.imageView.isHidden = false
                //                    self.imageView.image = newImage // 받아온 이미지를 update
                                }
                            }
                        } // process
                        
                    }
                }
                    
                }
                // POST 전송
                task.resume()
    }
    
    func uploadDiary(date: String, _ photo : UIImage, requestUrl : String, param : Dictionary<String, Any>){
                //함수 매개변수는 POST할 데이터, url
                
                let headers: HTTPHeaders = [
                        "Content-Type" : "multipart/form-data",
                        "accept" : "application/json"
                ]//HTTP 헤더
        
                //multipart 업로드
                AF.upload(multipartFormData: { (multipart) in
                    if let imageData = photo.jpegData(compressionQuality: 1) {
                        multipart.append(imageData, withName: "photo", fileName: "\(param["file_name"]).jpg", mimeType: "image/jpeg")
                        //이미지 데이터를 POST할 데이터에 덧붙임
                    }
                    for (key, value) in param {
                        multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)")
                        //이미지 데이터 외에 같이 전달할 데이터 (여기서는 user, emoji, date, content 등)
                    }
                }, to: "".getLocalURL()+requestUrl    //전달할 url
                ,method: .post        //전달 방식
                ,headers: headers).responseString(completionHandler: { (response) in    //헤더와 응답 처리
                    print("response --------> \n", response)
                    
                    print("response.value ", response.value!)
                    
                    if response.value! == "success"{
                        DispatchQueue.main.async{
                            self.uploadDelegate?.uploadGift()
                            self.navigationController?.popViewController(animated: true)
                            print("화면 이동")
//                            self.navigationController?.pushViewController(pushVC!, animated: true)
                            //뒤로가기 작업 필요
                            }
                    }else {
                        self.normalAlert(titles: "알림", messages: "네트워크 오류")
                    }
                    
                    if let err = response.error{    //응답 에러
                        print("error --------> \n", err)
                        return
                    }
                    
                    let json = response.data
                    
                    if (json != nil){
                        print("json --------> \n", json!)
                    }
                })
                
    }
}

