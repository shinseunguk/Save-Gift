//
//  GiftDetailController.swift
//  Save Gift
//
//  Created by mac on 2022/04/07.
//
// https://shimjifam.tistory.com/101 ------------> v28ue 세팅값

import Foundation
import UIKit

import FirebaseStorage
import Firebase

protocol detailDelegate {
    func refreshTableView(dicT : Dictionary<String, Any>)
}

class GiftDetailController : UIViewController{
    let LOG_TAG : String = "GiftDetailController"
    
    @IBOutlet weak var vBrandLabel: UILabel!
    @IBOutlet weak var vProductLabel: UILabel!
    @IBOutlet weak var vExpirationLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageExpandBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var presentBtn: UIButton!
    @IBOutlet weak var useynBtn: UIButton!
    
    var delegate : GiftDeleteDelegate?
    var delegate2 : GiftDeleteDelegate2?
    var delegate3 : GiftDeleteDelegate3?
    
    let localUrl : String = "".getLocalURL()
    
    let categoryArr = ["바코드 번호", "교환처", "상품명", "유효기간", "쿠폰상태", "등록일", "등록자"]
    var contentArr =  ["", "", "", "", "", "", ""]
//    var contentArr : [Any] = []
    
    let calendar = Calendar.current
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    let helper : Helper = Helper()
    
    var daysCount:Int = 0

    var imageUrl : String? = nil
    var seq : Int? = nil
    
    var param : Dictionary<String, Any> = [:]
    var dic : Dictionary<String, Any> = [:]
    
    var uiImage : UIImage? = nil
    
    var barcodeNumber : String? = nil
    var brandName : String? = nil
    var productName : String? = nil
    var expirationPeriod : String? = nil
    var use_yn : Int? = nil // 넘겨준 이유 --> 하단 버튼 enable 처리 때문
    var registrant : String? = nil
    var registrationDate : String? = nil
    
    var reviseBool : Bool = false
    var couponStatus : Bool = true

    override func viewDidLoad(){
        super.viewDidLoad()
        
        print("imageUrl --- > ", "".getLocalURL()+"/images/\(imageUrl!)")
        print("seq --- > ", seq!)
        
        
        
//        Init()
        viewLabelSetup()
        contentArrSetup()
        setupLayout()
//        calculateDays()
        tableView.allowsSelection = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(LOG_TAG)", #function)
        
        if reviseBool{
            print("reviseBool line => \(#line)")
            self.delegate?.giftDelete()
            self.delegate2?.giftDelete2()
            self.delegate3?.giftDelete3()
//                            self.dismiss(animated: true, completion: nil)
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func bottomBtnSetup(){
        if use_yn == 1{ //사용 했음
            print("\(LOG_TAG) \(#function) \(#line) use_yn --> ", use_yn!)
//            self.presentBtn.removeFromSuperview()
//            self.editBtn.removeFromSuperview()
            useynBtn.setTitle("미사용 처리", for: .normal)
        }else { // 사용 안했음
            print("\(LOG_TAG) \(#function) \(#line) use_yn --> ", use_yn!)
            useynBtn.setTitle("사용 처리", for: .normal)
        }
    }
    
    func viewLabelSetup(){
        vBrandLabel.text = brandName
        vProductLabel.text = productName
        vExpirationLabel.text = "~ \(expirationPeriod!) 까지"
    }
    
    func contentArrSetup(){
        
        let url = URL(string: "".getLocalURL()+"/images/\(imageUrl!)")
        DispatchQueue.global(qos: .userInteractive).async {
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data!)!
                }
        }
        
//        self.imageView.image = uiImage
        
        contentArr[0] = barcodeNumber!
        contentArr[1] = brandName!
        contentArr[2] = productName!
        contentArr[3] = expirationPeriod!
        
        //여기서 날짜에 따른 쿠폰 상태 확인해주고 set text
        if use_yn == 1{
            contentArr[4] = "사용불가"
        }else {
            contentArr[4] = "사용가능"
        }
        
        contentArr[5] = registrationDate!
        contentArr[6] = registrant!
        
        dic["barcode_number"] = barcodeNumber!
        dic["brand"] = brandName!
        dic["product_name"] = productName!
        dic["expiration_period"] = expirationPeriod!
        dic["use_yn"] = use_yn!
        dic["registration_date"] = registrationDate!
        dic["registrant"] = registrant!
        dic["seq"] = seq!
        
        bottomBtnSetup()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UINib(nibName: "GiftDetailBarcodeTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailBarcodeTableViewCell")
        self.tableView.register(UINib(nibName: "GiftDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "GiftDetailTableViewCell")
    }
    
    func Init(){
        reviseBool = true
        
        param["seq"] = seq
        requestPost(requestUrl: "/gift/detail", param: param)
    }
    
    func setupLayout(){
        imageExpandBtn.layer.cornerRadius = 5
        editBtn.layer.cornerRadius = 5
        presentBtn.layer.cornerRadius = 5
        useynBtn.layer.cornerRadius = 5
        
        print("use_yn ----> ",use_yn!)
    }
    
    @IBAction func imageExpandAction(_ sender: Any) {
        print("전체화면으로 보기")
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftDetailFullScreen") as? GiftDetailFullScreenController else{
            return
        }
        
        pushVC.uiImage = self.imageView.image
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true, completion: nil)
    }
    
    @IBAction func editAction(_ sender: Any) {
        actionSheetAlert(title: "기프티콘 편집하기", content1: "기프티콘 삭제", content2: "기프티콘 수정")
    }
    
    @IBAction func presentAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "ID") != nil{ // 로그인 o
            if useynBtn.titleLabel?.text == "미사용 처리"{ //선물 불가상태
                normalPresentAlert(title: "알림", message: "쿠폰상태가 사용불가인 쿠폰은 선물할 수 없습니다.")
            }else { //선물가능
                actionSheetAlert(title: "기프티콘 선물하기", content1: "기프티콘 공유(준비중)", content2: "기프티콘 선물")
            }
        } else{
            print("\(#function) else")
            normalPresentAlert(title: "알림", message: "로그인 후 이용 가능한 서비스입니다.")
        }
    }
    
    @IBAction func useynAction(_ sender: Any) {
        if useynBtn.titleLabel?.text == "미사용 처리"{ // 이미 사용 혹은 사용 불가 -> 미사용
            if couponStatus {
                normalAlertUseYn(title: "알림", message: "미사용 처리 하시겠습니까?")
            }else { //유효기간이 지났음에도 쿠폰상태를 사용가능으로 변경하는 경우
                normalAlertUseYn(title: "알림", message: "이미 유효기간이 지난 기프티콘은 미사용 처리할 수 없습니다.\n 유효기간과 쿠폰상태를 변경 하고 처리 해주세요.\n 기프티콘 수정 화면으로 이동하시겠습니까?")
            }
        }else { //사용 가능 -> 이미 사용
            normalAlertUseYn(title: "알림", message: "사용완료 처리 하시겠습니까?")
        }
    }
    
    func actionSheetAlert(title: String, content1: String, content2: String){
        if title == "기프티콘 편집하기"{
            let alert =  UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

            let library =  UIAlertAction(title: content1, style: .default) {
                (action) in self.normalAlertUseYn(title: "알림", message: "정말로 기프티콘을 삭제하시겠습니까?")
            }

            let camera =  UIAlertAction(title: content2, style: .default) {
                (action) in self.reviseGiftcon()
            }

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }else { // 기프티콘 선물하기
            let alert =  UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)

            let library =  UIAlertAction(title: content1, style: .default) {
                (action) in self.normalPresentAlert(title: "알림", message: "해당 기능은 서비스 준비중입니다.")
            }

            let camera =  UIAlertAction(title: content2, style: .default) {
                (action) in self.presentGiftcon()
            }

            let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(library)
            alert.addAction(camera)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
    }
    
    func normalAlertUseYn(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if message == "정말로 기프티콘을 삭제하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "삭제", style: .destructive, handler : {_ in self.deleteGiftCon()})
            alert.addAction(defaultAction)
        }else if message == "사용완료 처리 하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "확인", style: .destructive, handler : {_ in self.useYnGiftCon(index: "사용완료")})
            alert.addAction(defaultAction)
        }else if message == "미사용 처리 하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "확인", style: .destructive, handler : {_ in self.useYnGiftCon(index: "미사용")})
            alert.addAction(defaultAction)
        }else if message == "이미 유효기간이 지난 기프티콘은 미사용 처리할 수 없습니다.\n 유효기간과 쿠폰상태를 변경 하고 처리 해주세요.\n 기프티콘 수정 화면으로 이동하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "이동", style: .destructive, handler : {_ in self.useYnGiftCon(index: "수정화면")})
            alert.addAction(defaultAction)
        }else {
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler : nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func normalPresentAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        if message == "쿠폰상태가 사용불가인 쿠폰은 선물할 수 없습니다."{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
        }else if message == "해당 기능은 서비스 준비중입니다."{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(defaultAction)
        }else {
            let defaultAction = UIAlertAction(title: "로그인 화면으로 이동", style: .destructive, handler : {_ in self.loginGo()})
            alert.addAction(defaultAction)
            let cancelAction = UIAlertAction(title: "확인", style: .default, handler : nil)
            alert.addAction(cancelAction)
        }
        present(alert, animated: true, completion: nil)
    }
    
    func presentGiftcon(){
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "giftRankVC") as? GiftFriendController else{
            return
        }
        
        pushVC.modalPresentationStyle = .fullScreen
        self.present(pushVC, animated: true, completion: nil)
    }
    
    func reviseGiftcon(){
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftRegisterVC") as? GiftRegisterController else{
            return
        }
        
        pushVC.reviseDic = self.dic
        pushVC.reviseImage = self.imageView.image
        pushVC.detailDelegate = self
        self.present(pushVC, animated: true, completion: nil)
    }
    
    func deleteGiftCon(){
        param["page"] = "GiftDetail"
        param["img_url"] = imageUrl!
        param["seq"] = seq!
        deleteGiftConRequest(requestUrl: "/gift/delete", param: param)
    }
    
    func useYnGiftCon(index : String){
        //로직 구현해야함 ..
        if index == "사용완료"{
            print("사용완료")
            param["use_yn"] = 1
            param["seq"] = seq!
            useYnRequest(requestUrl: "/gift/useyn", param: param)
        }else if index == "미사용"{
            print("미사용")
            param["use_yn"] = 0
            param["seq"] = seq!
            useYnRequest(requestUrl: "/gift/useyn", param: param)
        }else {
            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftRegisterVC") as? GiftRegisterController else{
                return
            }
            
            pushVC.reviseDic = self.dic
            pushVC.reviseImage = self.imageView.image
            pushVC.detailDelegate = self
            self.present(pushVC, animated: true, completion: nil)
        }
    }
    
    func loginGo(){
        print("loginGO")
        self.delegate?.goToLogin()
        self.delegate2?.goToLogin()
        self.delegate3?.goToLogin()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func deleteGiftConRequest(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("deleteGiftConRequest param.... ", param)
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
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
                        return
                    }

                    var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    
                    print(responseString!)
                    DispatchQueue.main.async {
                        if responseString! == "true"{
                            self.delegate?.giftDelete()
                            self.delegate2?.giftDelete2()
                            self.delegate3?.giftDelete3()
//                            self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else {
                            print("기프티콘 삭제 실패")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func requestPost(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("param.... ", param)
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

                // URLSession 객체를 통해 전송, 응답값 처리
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    // 서버가 응답이 없거나 통신이 실패
                    if let e = error {
                        print("\(self.LOG_TAG) An error has occured: \(e.localizedDescription)")
                        self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "네트워크에 접속할 수 없습니다.", message: "네트워크 연결 상태를 확인해주세요.", completeTitle: "확인", nil)
                        return
                    }

                var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                    print("GiftDetail responseString \n", responseString!)
                    print("/gift/detail data ----> \n", data! as Any)
                    print("/gift/detail response ----> \n", response! as Any)

                    var responseStringA = responseString as! String
                    print("responseStringA ===> ", responseStringA)
//
                    if responseStringA.count != 2{

                        responseStringA = responseStringA.replacingOccurrences(of: "]", with: "")
                        responseStringA = responseStringA.replacingOccurrences(of: "[", with: "")

                        print("responseStringA ---- > \n",responseStringA)

                        let arr = responseStringA.components(separatedBy: "},")
                        print("arr0 --->", arr[0])

                        self.dic = self.helper.jsonParser7(stringData: arr[0] as! String, data1: "barcode_number", data2: "brand", data3: "product_name", data4: "expiration_period", data5: "use_yn", data6:"registration_date", data7: "registrant");

                        print("self.dic ----> \n", self.dic)

                        DispatchQueue.main.async {

                            self.contentArr[0] = self.dic["barcode_number"] as! String
                            self.contentArr[1] = self.dic["brand"] as! String
                            self.contentArr[2] = self.dic["product_name"] as! String
                            self.contentArr[3] = self.dic["expiration_period"] as! String

                            //여기서 날짜에 따른 쿠폰 상태 확인해주고 set text
                            if self.dic["use_yn"] as! Int == 1{
                                self.contentArr[4] = "사용불가"
                            }else {
                                self.contentArr[4] = "사용가능"
                            }

                            self.contentArr[5] = self.dic["registration_date"] as! String
                            self.contentArr[6] = self.dic["registrant"] as! String

                            
                            print("\(#line) reloadData()")
                            self.tableView.reloadData()
                        }

                    }
                }
                // POST 전송
                task.resume()
    }
    
    func useYnRequest(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
        print("param.... ", param)
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
                                self.delegate?.giftDelete()
                                self.delegate2?.giftDelete2()
                                self.delegate3?.giftDelete3()
    //                            self.dismiss(animated: true, completion: nil)
                                self.presentingViewController?.dismiss(animated: true, completion: nil)
                            }else {
                                print("기프티콘 수정 실패")
                            }
                        }
                    
//
                }
                // POST 전송
                task.resume()
    }
    
}

extension GiftDetailController : UITableViewDelegate, UITableViewDataSource, detailDelegate{
    func refreshTableView(dicT : Dictionary<String, Any>) {
        print("refreshTableView()")
        print("\(#function) dic => ", dicT)
        
        contentArr[0] = dicT["barcode_number"] as! String//barcodeNumber!
        contentArr[1] = dicT["brand"] as! String
        contentArr[2] = dicT["product_name"] as! String
        contentArr[3] = dicT["expiration_period"] as! String
        
        //여기서 날짜에 따른 쿠폰 상태 확인해주고 set text
        if dicT["use_yn"] as! Int == 1{//
            contentArr[4] = "사용불가"
        }else {
            contentArr[4] = "사용가능"
        }
        
        contentArr[5] = dicT["registration_date"] as! String
        contentArr[6] = dicT["registrant"] as! String
        
        tableView.reloadData()
//        Init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GiftDetailTableViewCell") as! GiftDetailTableViewCell
        
        
        cell.copyBtn.layer.cornerRadius = 5
        cell.copyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cell.copyBtn.titleLabel?.font = .systemFont(ofSize: 14)
        
        cell.copyBtn.addTarget(self, action: #selector(normalAlert), for: .touchUpInside)
        
        // 바코드번호 클립보드저장 버튼
        if indexPath.row != 0 {
            cell.copyBtn.isHidden = true
        }
        if indexPath.row != 3{
            cell.dDayLabel.isHidden = true
        }else {
            cell.dDayLabel.isHidden = false
            print("\(#line) indexPath.row \(indexPath.row)")
            let resultDDay : Int = calculateDays(availableDate: contentArr[3])
            if resultDDay == 0 {
                cell.dDayLabel.textColor = UIColor.systemBlue
                cell.dDayLabel.text = "(오늘까지)"
            }else if resultDDay > 0 {
                cell.dDayLabel.textColor = UIColor.red
                cell.dDayLabel.text = "(D+\(resultDDay))"
                couponStatus = false
//                contentArr[4] = "사용불가" // 20220514, 사용완료 => 미사용 이슈로 인한 주석처리
            }else if resultDDay < 0 {
                cell.dDayLabel.textColor = UIColor.systemGreen
                cell.dDayLabel.text = "(D\(resultDDay))"
            }
        }
        
        //미사용, 사용 set Color
        if indexPath.row == 4{
            if contentArr[4] == "사용가능"{
                cell.secondLabel.textColor = UIColor.systemGreen
            }else if contentArr[4] == "사용불가"{
                cell.secondLabel.textColor = UIColor.red
            }
        }else {
            cell.secondLabel.textColor = UIColor.black
        }
        
        
        cell.firstLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.firstLabel.text = categoryArr[indexPath.row]
        cell.secondLabel.text = contentArr[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 50
       }
    
    func calculateDays(availableDate : String) -> Int {
        print("calculateDays ",availableDate)
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.date(from: availableDate) // 유효기간
        daysCount = days(date: startDate!, date1: helper.formatDateToday())
        
        print("daysCount ", daysCount)
        return daysCount
    }
    
    func days(date: Date, date1 : String) -> Int {
        
        let formatter = DateFormatter() //객체 생성
        formatter.dateStyle = .long
        formatter.timeStyle = .medium
        formatter.dateFormat = "yyyy-MM-dd" //데이터 포멧 설정
        let dateString = formatter.string(from: date) //문자열로 바꾸기
        
        let dateInt1 : Int = Int(date1.replacingOccurrences(of: "-", with: ""))! //오늘 날짜
        let dateInt2 : Int = Int(dateString.replacingOccurrences(of: "-", with: ""))! //입력된 날짜
        
        print("date1Int1 -----> 오늘    날짜 -->", dateInt1)
        print("date1Int2 -----> 유효기간 날짜 -->", dateInt2)
        
//        print("date2 ", date1)
//        print("dateString ", dateString)
//        print("current ", currentDate)
        
        if dateInt1 == dateInt2 {
            return 0
        }else if dateInt1 > dateInt2 {
            print("dateInt1 > dateInt2")
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }else if dateInt1 < dateInt2 {
            print("dateInt1 < dateInt2") // 오늘날짜 < 유효기간 날짜
            print("log....1 ", calendar.dateComponents([.day], from: date, to: currentDate).day!-1)
            print("log....2 ", -(calendar.dateComponents([.day], from: date, to: currentDate).day!-1))
            print("log....3 ", calendar.dateComponents([.day], from: date, to: currentDate).day!)
//            if calendar.dateComponents([.day], from: date, to: currentDate).day! == 0 {
//                return 1
//            }else {
               return calendar.dateComponents([.day], from: date, to: currentDate).day!-1
//            }
        }
        
        return calendar.dateComponents([.day], from: date, to: currentDate).day!
    }
    
    @objc func normalAlert(){
        let alert = UIAlertController(title: "알림", message: "바코드 번호가\n 클립보드에 복사되었습니다.", preferredStyle: UIAlertController.Style.alert)
        let defaultAction = UIAlertAction(title: "확인", style: .default, handler : nil)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
}
