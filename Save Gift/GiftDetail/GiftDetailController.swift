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
    func detailToFriendDelegate()
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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    
    var delegate : GiftDeleteDelegate?
    var delegate2 : GiftDeleteDelegate2?
    var delegate3 : GiftDeleteDelegate3?
    var presentProtocol1 : presentProtocol1?
    var presentProtocol2 : presentProtocol2?
    var presentProtocol3 : presentProtocol3?
    
    var detailToFriend : DetailToFriendDelegate?
    
    let localUrl : String = "".getLocalURL()
    
    var categoryArr = ["바코드 번호", "교환처", "상품명", "유효기간", "쿠폰상태", "등록일", "등록자"]
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
    var presentParam : Dictionary<String, Any> = [:]
    
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
    
    var presentIndex : Bool = false
    var presentId : String? = nil
    
    var presentPage : Int = 0 // 선물받은
    var presentMessage : String? = nil // 선물할
    
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var uiViewHeight: NSLayoutConstraint!
    let sendPresentBtn = UIButton()

    override func viewDidLoad(){
        super.viewDidLoad()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped))
                        imageView.addGestureRecognizer(tapGR)
                        imageView.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("seq --- > ", seq!)
        
        print("presentIndex ", presentIndex)
        print("presentPage ", presentPage)
        print("presentId \(#line)", presentId)
        
        if presentPage != 0 {
            if presentPage == 0 || presentPage == 1 {
                categoryArr[6] = "선물 한 사람"
            }
        }
//        categoryArr[6] = "선물 한 사람"
        
        presentPageSetUp()
        presentSetUp()
//        Init()
        viewLabelSetup()
        contentArrSetup()
        setupLayout()
//        calculateDays()
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
    }
    
    func presentPageSetUp(){
        if presentPage != 0 {
            if presentPage == 1 {
                categoryArr.append("선물과 함께 보낸 메시지")
                contentArr.append("\(presentMessage)")
                editBtn.removeFromSuperview()
                presentBtn.removeFromSuperview()
                useynBtn.removeFromSuperview()
                imageExpandBtn.removeFromSuperview()
                
                //tableView layout
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.register(UINib(nibName: "PresentMessageViewTableViewCell", bundle: nil), forCellReuseIdentifier: "PresentMessageViewTableViewCell")
                tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
                tableViewHeight.constant = 500
                //
                
                //sendPresentBtn layout
                sendPresentBtn.layer.cornerRadius = 5
                sendPresentBtn.backgroundColor = .systemBlue
                sendPresentBtn.setTitle("선물 사용처리", for: .normal)
                sendPresentBtn.addTarget(self, action: #selector(cancelPresent), for: .touchUpInside)
                scrollView.addSubview(sendPresentBtn)
                
                sendPresentBtn.translatesAutoresizingMaskIntoConstraints = false
                sendPresentBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
                sendPresentBtn.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
                sendPresentBtn.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
                sendPresentBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
                //
                
                //view layout
                uiView.translatesAutoresizingMaskIntoConstraints = false
                uiViewHeight.constant = 1300
                //
            }else if presentPage == 2 {
                categoryArr.append("선물과 함께 보낸 메시지")
                contentArr.append("\(presentMessage)")
                editBtn.removeFromSuperview()
                presentBtn.removeFromSuperview()
                useynBtn.removeFromSuperview()
                imageExpandBtn.removeFromSuperview()
                
                //tableView layout
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.register(UINib(nibName: "PresentMessageViewTableViewCell", bundle: nil), forCellReuseIdentifier: "PresentMessageViewTableViewCell")
                tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
                tableViewHeight.constant = 500
                //
                
                //sendPresentBtn layout
                sendPresentBtn.layer.cornerRadius = 5
                sendPresentBtn.backgroundColor = .systemBlue
                sendPresentBtn.setTitle("선물 미사용처리", for: .normal)
                sendPresentBtn.addTarget(self, action: #selector(cancelPresent), for: .touchUpInside)
                scrollView.addSubview(sendPresentBtn)
                
                sendPresentBtn.translatesAutoresizingMaskIntoConstraints = false
                sendPresentBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
                sendPresentBtn.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
                sendPresentBtn.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
                sendPresentBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
                //
                
                //view layout
                uiView.translatesAutoresizingMaskIntoConstraints = false
                uiViewHeight.constant = 1300
                //
            }else if presentPage == 3 {
                categoryArr.append("보낸 메시지")
                contentArr.append("\(presentMessage)")
                editBtn.removeFromSuperview()
                presentBtn.removeFromSuperview()
                useynBtn.removeFromSuperview()
                imageExpandBtn.removeFromSuperview()
                
                //tableView layout
                tableView.translatesAutoresizingMaskIntoConstraints = false
                tableView.register(UINib(nibName: "PresentMessageViewTableViewCell", bundle: nil), forCellReuseIdentifier: "PresentMessageViewTableViewCell")
                tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
                tableViewHeight.constant = 500
                //
                
                //sendPresentBtn layout
                sendPresentBtn.layer.cornerRadius = 5
                sendPresentBtn.backgroundColor = .systemBlue
                sendPresentBtn.setTitle("선물 취소하기", for: .normal)
                sendPresentBtn.addTarget(self, action: #selector(cancelPresent), for: .touchUpInside)
                scrollView.addSubview(sendPresentBtn)
                
                sendPresentBtn.translatesAutoresizingMaskIntoConstraints = false
                sendPresentBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
                sendPresentBtn.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
                sendPresentBtn.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
                sendPresentBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
                //
                
                //view layout
                uiView.translatesAutoresizingMaskIntoConstraints = false
                uiViewHeight.constant = 1300
                //
            }
        }
    }
    
    func presentSetUp(){
        if presentIndex { // friend -> Unused -> Detail
            helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "선물과 함께 보낼 메시지를 작성후 선물을 보내보세요!", completeTitle: "확인", nil)
            
            categoryArr.append("선물보낼 메시지")
            contentArr.append("")
            editBtn.removeFromSuperview()
            presentBtn.removeFromSuperview()
            useynBtn.removeFromSuperview()
            imageExpandBtn.removeFromSuperview()
            
            //tableView layout
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.register(UINib(nibName: "PresentMessageTableViewCell", bundle: nil), forCellReuseIdentifier: "PresentMessageTableViewCell")
            tableView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            tableViewHeight.constant = 500
            //

            //sendPresentBtn layout
            sendPresentBtn.layer.cornerRadius = 5
            sendPresentBtn.backgroundColor = .systemBlue
            sendPresentBtn.setTitle("선물 보내기", for: .normal)
            sendPresentBtn.addTarget(self, action: #selector(sendPresent), for: .touchUpInside)
            scrollView.addSubview(sendPresentBtn)
            
            sendPresentBtn.translatesAutoresizingMaskIntoConstraints = false
            sendPresentBtn.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20).isActive = true
            sendPresentBtn.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
            sendPresentBtn.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -20).isActive = true
            sendPresentBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
            //
            
            //view layout
            uiView.translatesAutoresizingMaskIntoConstraints = false
            uiViewHeight.constant = 1300
            //
        }
    }
    
    @objc func imageTapped(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            print("imageTapped")
            self.view.endEditing(true)
        }
    }
    
    @objc func sendPresent(){
        print("sendPresent()")
        let index = IndexPath(row: 7, section: 0)
        let cell: PresentMessageTableViewCell = self.tableView.cellForRow(at: index) as! PresentMessageTableViewCell
        presentMessage = cell.messageTextField.text
        contentArr[7] = presentMessage!
        
        if presentMessage! == ""{ // 아무것도 쓰지 않은상태
            normalAlertUseYn(title: "알림", message: "선물과 함께 보낼 메시지 없이 선물을 보내시겠습니까?")
        }else {
            normalAlertUseYn(title: "알림", message: "해당 기프티콘을 선물하시겠습니까?")
        }
    }
    
    @objc func cancelPresent(){ // 버튼 타이틀에 따라 분기
        
        if sendPresentBtn.titleLabel?.text == "선물 사용처리"{
            normalAlertUseYn(title: "알림", message: "선물 사용처리 하시겠습니까?\n\n 미사용 -> 사용 (사용불가)")
            presentProtocol1?.presentPageReload()
        }else if sendPresentBtn.titleLabel?.text == "선물 미사용처리"{
            normalAlertUseYn(title: "알림", message: "선물 미사용처리 하시겠습니까?\n\n 사용 -> 미사용 (사용가능)")
            presentProtocol2?.presentPageReload()
        }else if sendPresentBtn.titleLabel?.text == "선물 취소하기"{
            if use_yn == 1{ // 사용불가
                if presentPage != 0 {
                    if presentPage == 3{
                        sendPresentBtn.backgroundColor = .systemGray2
                        helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "이미 사용 완료된 선물은 취소할 수 없습니다.", completeTitle: "확인", nil)
                    }
                }
            }else { // 사용안함
                sendPresentBtn.backgroundColor = .systemBlue
                normalAlertUseYn(title: "알림", message: "선물을 취소 하시겠습니까?")
            }

            
            presentProtocol3?.presentPageReload()
        }
        
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
            
            if presentPage != 0 {
                if presentPage == 3{
                    sendPresentBtn.backgroundColor = .systemGray2
                }
            }
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
//                actionSheetAlert(title: "기프티콘 선물하기", content1: "기프티콘 공유(준비중)", content2: "기프티콘 선물")
                self.presentGiftcon()
            }
        } else{
            print("\(#function) else")
            normalPresentAlert(title: "알림", message: "로그인 후 이용 가능한 서비스입니다.")
        }
    }
    
    @IBAction func useynAction(_ sender: Any) {
        print("getRecentDictionary() as! Int ", getRecentDictionary()["use_yn"] as! Int)
        
        let resultDDay : Int = calculateDays(availableDate: getRecentDictionary()["expiration_period"] as! String)
        if resultDDay > 0 {
            couponStatus = false
        }else {
            couponStatus = true
        }
        
        if getRecentDictionary()["use_yn"] as! Int == 1{ // 이미 사용 혹은 사용 불가 -> 미사용
            if couponStatus {
                normalAlertUseYn(title: "알림", message: "미사용 처리 하시겠습니까?")
            }else { //유효기간이 지났음에도 쿠폰상태를 사용가능으로 변경하는 경우
                normalAlertUseYn(title: "알림", message: "이미 유효기간이 지난 기프티콘은 미사용 처리할 수 없습니다.\n 유효기간과 쿠폰상태를 변경 하고 처리 해주세요.\n 기프티콘 수정 화면으로 이동하시겠습니까?")
            }
        }else { //사용 가능 -> 이미 사용
            normalAlertUseYn(title: "알림", message: "사용 완료 처리 하시겠습니까?")
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
        }else if message == "사용 완료 처리 하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : {_ in self.useYnGiftCon(index: "사용완료")})
            alert.addAction(defaultAction)
        }else if message == "미사용 처리 하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : {_ in self.useYnGiftCon(index: "미사용")})
            alert.addAction(defaultAction)
        }else if message == "이미 유효기간이 지난 기프티콘은 미사용 처리할 수 없습니다.\n 유효기간과 쿠폰상태를 변경 하고 처리 해주세요.\n 기프티콘 수정 화면으로 이동하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "이동", style: .destructive, handler : {_ in self.useYnGiftCon(index: "수정화면")})
            alert.addAction(defaultAction)
        }else if message == "선물과 함께 보낼 메시지 없이 선물을 보내시겠습니까?" || message == "해당 기프티콘을 선물하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler : {_ in self.presentFriendToDetail()})
            alert.addAction(defaultAction)
        }else if message == "선물을 취소 하시겠습니까?"{
            let defaultAction = UIAlertAction(title: "선물 취소", style: .default, handler : {_ in self.presentFriendToDetail()})
            alert.addAction(defaultAction)
        }else if message == "선물 사용처리 하시겠습니까?\n\n 미사용 -> 사용 (사용불가)" || message == "선물 미사용처리 하시겠습니까?\n\n 사용 -> 미사용 (사용가능)" {
            let defaultAction = UIAlertAction(title: "확인", style: .default, handler :  {_ in self.presentFriendToDetail()})
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
    
    func presentFriendToDetail(){ // 선물 보내기 / 선물 취소하기 분기 태워야함.
        var btnTitle = sendPresentBtn.titleLabel?.text
        print("btnTitle ", btnTitle!)
        
        print("param =====> ", param)
        print("seq ..", seq!)
        print(contentArr[7])
        
        if btnTitle! == "선물 보내기" {
            presentGiftConRequest(requestUrl: "/gift/present", seq: seq!)
        }else {
            if btnTitle! == "선물 사용처리" { // use_yn 변경 0 -> 1
                param["index"] = "one"
                param["seq"] = seq
            }else if btnTitle! == "선물 미사용처리" { // use_yn 변경 1 -> 0
                param["index"] = "two"
                param["seq"] = seq
            }else if btnTitle! == "선물 취소하기" { // present_id, present_message null 처리
                param["index"] = "three"
                param["seq"] = seq
            }
            presentTabRequest(requestUrl: "/present/tab", param: param)
        }
    }
    
    func presentGiftcon(){
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "giftRankVC") as? GiftFriendController else{
            return
        }
        
        pushVC.modalPresentationStyle = .fullScreen
        pushVC.index = "선물하기"
        pushVC.presentIndex = true
        pushVC.detailToFriend = dic
        pushVC.img_url = imageUrl
        pushVC.detailDelegate = self
        self.present(pushVC, animated: true, completion: nil)
    }
    
    func reviseGiftcon(){
        guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftRegisterVC") as? GiftRegisterController else{
            return
        }
        
        pushVC.reviseDic = getRecentDictionary()
        pushVC.reviseImage = self.imageView.image
        pushVC.detailDelegate = self
        self.present(pushVC, animated: true, completion: nil)
    }
    
    func getRecentDictionary() -> Dictionary<String, Any> {
        for x in 0...6 {
            let cell: GiftDetailTableViewCell = self.tableView.cellForRow(at: IndexPath(row: x, section: 0)) as! GiftDetailTableViewCell
            
            switch x {
            case 0:
                let text : String? = cell.secondLabel.text
                print("text0 ", text!)
                dic["barcode_number"] = text!
                break
            case 1:
                let text : String? = cell.secondLabel.text
                print("text1 ", text!)
                dic["brand"] = text!
                break
            case 2:
                let text : String? = cell.secondLabel.text
                print("text2 ", text!)
                dic["product_name"] = text!
                break
            case 3:
                let text : String? = cell.secondLabel.text
                print("text3 ", text!)
                dic["expiration_period"] = text!
                break
            case 4:
                let text : String? = cell.secondLabel.text
                print("text4 ", text!)
                if text! == "사용가능" {
                    dic["use_yn"] = 0
                }else {
                    dic["use_yn"] = 1
                }
                break
            case 5:
                let text : String? = cell.secondLabel.text
                print("text5 ", text!)
                dic["registration_date"] = text!
                break
            case 6:
                let text : String? = cell.secondLabel.text
                print("text6 ", text!)
                dic["registrant"] = text!
                break
            default:
                print("default")
            }
        }
        return dic
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
            param = getRecentDictionary()
            param["use_yn"] = 1
            param["seq"] = seq!
            useYnRequest(requestUrl: "/gift/useyn", param: param)
        }else if index == "미사용"{
            print("미사용")
            param = getRecentDictionary()
            param["use_yn"] = 0
            param["seq"] = seq!
            useYnRequest(requestUrl: "/gift/useyn", param: param)
        }else {
            guard let pushVC = self.storyboard?.instantiateViewController(identifier: "GiftRegisterVC") as? GiftRegisterController else{
                return
            }
            
            pushVC.reviseDic = getRecentDictionary()
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
    
    func presentTabRequest(requestUrl : String!, param : Dictionary<String, Any>) -> Void{
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
                            self.presentProtocol1?.presentPageReload()
                            self.presentProtocol2?.presentPageReload()
                            self.presentProtocol3?.presentPageReload()
                            
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else {
                            print("기프티콘 선물 실패")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func deletePresent(requestUrl : String!, seq : Int!) -> Void{
        presentParam["seq"] = seq
        presentParam["present_message"] = contentArr[7]
        presentParam["present_id"] = presentId!
        
        let paramData = try! JSONSerialization.data(withJSONObject: presentParam)
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
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "선물완료", completeTitle: "확인", nil)
                            self.delegate?.giftPresent()
                            self.detailToFriend?.detailToFriendFunc()
//                            self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else {
                            print("기프티콘 선물 실패")
                        }
                    }
                }
                // POST 전송
                task.resume()
    }
    
    func presentGiftConRequest(requestUrl : String!, seq : Int!) -> Void{
        presentParam["seq"] = seq
        presentParam["present_message"] = contentArr[7]
        presentParam["present_id"] = presentId!
        
        let paramData = try! JSONSerialization.data(withJSONObject: presentParam)
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
                            self.helper.showAlertAction1(vc: self, preferredStyle: .alert, title: "알림", message: "선물완료", completeTitle: "확인", nil)
                            self.delegate?.giftPresent()
                            self.detailToFriend?.detailToFriendFunc()
//                            self.dismiss(animated: true, completion: nil)
                            self.presentingViewController?.dismiss(animated: true, completion: nil)
                        }else {
                            print("기프티콘 선물 실패")
                        }
                    }
                }
                // POST 전송
                task.resume()
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
    func detailToFriendDelegate() {
        print("\(#function)")
//        dismiss(animated: true, completion: nil)
        self.delegate?.giftDelete()
        self.delegate2?.giftDelete2()
        self.delegate3?.giftDelete3()
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
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
        reviseBool = true
//        Init()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("categoryArr.count ", categoryArr.count)
        return categoryArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "GiftDetailTableViewCell") as! GiftDetailTableViewCell
        if presentPage != 0{
            cell.copyBtn.isHidden = true
        }
        if indexPath.row != 7 {
            cell.copyBtn.layer.cornerRadius = 5
            cell.copyBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
            cell.copyBtn.titleLabel?.font = .systemFont(ofSize: 14)
            
            cell.copyBtn.addTarget(self, action: #selector(normalAlert), for: .touchUpInside)
            
            // 바코드번호 클립보드저장 버튼
            if indexPath.row != 0 || presentIndex{ // 바코드가 아니거나 친구 -> 선물로 넘어올때
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
        }else { // 선물과 함께 보낼 메시지 row
            if presentIndex { // => 선물보내기
                let customCell1 = tableView.dequeueReusableCell(withIdentifier: "PresentMessageTableViewCell") as! PresentMessageTableViewCell
                customCell1.messageLabel.text = "선물과 함께 보낼 메시지"
                customCell1.messageLabel.font = UIFont.boldSystemFont(ofSize: 14)
                
                customCell1.messageTextField.attributedPlaceholder = NSAttributedString(string: "선물과 함께 보낼 메시지를 작성해주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(displayP3Red: 144/255, green: 144/255, blue: 149/255, alpha: 1)])
                return customCell1
            }else { //  => 선물함
                let customCell2 = tableView.dequeueReusableCell(withIdentifier: "PresentMessageViewTableViewCell") as! PresentMessageViewTableViewCell
                
                if presentPage == 1 || presentPage == 2{
                    customCell2.upLabel.text = "선물과 함께 보낸 메시지"
                }else if presentPage == 3 {
                    customCell2.upLabel.text = "내가 보낸 메시지"
                }
                customCell2.upLabel.font = UIFont.boldSystemFont(ofSize: 14)
                
                if presentMessage != nil && presentMessage != ""{
                    customCell2.downLabel.text = presentMessage
                    customCell2.downLabel.textColor = .systemBlue
                }else {
                    customCell2.downLabel.textAlignment = .center
                    customCell2.downLabel.textColor = .systemRed
                    customCell2.downLabel.text = "전달된 메시지가 없습니다 😢"
                }
                
                return customCell2
            }
        }
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row != 7 {
                return 50
            }else { // 선물과 함께 보낼 메시지 row
                return 142
            }
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
        
//        print("date1Int1 -----> 오늘    날짜 -->", dateInt1)
//        print("date1Int2 -----> 유효기간 날짜 -->", dateInt2)
        
//        print("date2 ", date1)
//        print("dateString ", dateString)
//        print("current ", currentDate)
        
        if dateInt1 == dateInt2 {
            return 0
        }else if dateInt1 > dateInt2 {
//            print("dateInt1 > dateInt2")
            return calendar.dateComponents([.day], from: date, to: currentDate).day!
        }else if dateInt1 < dateInt2 {
//            print("dateInt1 < dateInt2") // 오늘날짜 < 유효기간 날짜
//            print("log....1 ", calendar.dateComponents([.day], from: date, to: currentDate).day!-1)
//            print("log....2 ", -(calendar.dateComponents([.day], from: date, to: currentDate).day!-1))
//            print("log....3 ", calendar.dateComponents([.day], from: date, to: currentDate).day!)
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
