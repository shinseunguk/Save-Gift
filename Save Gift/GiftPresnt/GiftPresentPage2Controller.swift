//
//  GiftPresentPage2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/04/19.
//

import Foundation
import UIKit
import DropDown

protocol presentProtocol2 : AnyObject{
    func presentPageReload()
}

class GiftPresentPage2Controller : UIViewController{
    let LOG_TAG : String = "GiftPresentPage2Controller"
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var filterButton: UIButton!
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 21))
    
    let helper : Helper = Helper()
    //cocoa pod
    let dropDown = DropDown()
    
    var dic : Dictionary<String, Any> = [:]

    let deviceID : String? = UserDefaults.standard.string(forKey: "device_id")
    let localUrl : String = "".getLocalURL()

    var param : Dictionary<String, Any> = [:]
    
    var index : Int = 0
    
    var dicArr : [String] = []
    
    //기기 세로길이
    let screenHeight = UIScreen.main.bounds.size.height
    //기기 가로길이 구하기
    let screenWidth = UIScreen.main.bounds.size.width
    
    var viewPagerArr = ["Unused", "Used", "All"]
    var thumbnail: Array<UIImage> = []

    var brandNameLabelArr : [String] = []
    var productNameLabelArr : [String] = []
    var barcodeNumberArr : [String] = []
    var expirationPeriodLabelArr : [String] = []
    var useYn : [Int] = []
    var registrationDateArr : [String] = []
    var cellImageViewArr : [String] = []
    var seqArr : [Int] = []
    var registrantArr : [String] = []
    var presentIdArr : [String] = []
    var presentCheckArr : [Int] = []
    var presentMessageArr : [String] = []
    
    var uiImageArr : [UIImage] = []
    var presentIndex : Bool = false
    var presentId : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //드롭다운 btnInit
        dropDownInit()
        
        //setupFlowLayout
        setupFlowLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("\(#function) viewDidAppear")
        if UserDefaults.standard.string(forKey: "ID") != nil { //로그인
            //서버 통신후 사용자 혹은 로컬기기 -> DB에 저장되어 있는 값 가져오기
            LoginSetupInit()
        }else { //비로그인
//            bLoginSetupInit()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("\(LOG_TAG) viewWillDisappear")
        
        label.removeFromSuperview()
//        arrRemoveAll()
    }
    
    func arrRemoveAll(){
        brandNameLabelArr.removeAll()
        productNameLabelArr.removeAll()
        barcodeNumberArr.removeAll()
        expirationPeriodLabelArr.removeAll()
        useYn.removeAll()
        registrantArr.removeAll()
        cellImageViewArr.removeAll()
        seqArr.removeAll()
        registrantArr.removeAll()
        uiImageArr.removeAll()
        presentIdArr.removeAll()
        presentCheckArr.removeAll()
        presentMessageArr.removeAll()
    }
    
    func LoginSetupInit(){
        print("로그인 setUP")
        
        // 로그인
        param["user_id"] = UserDefaults.standard.string(forKey: "ID")!
        param["index"] = "login"
        param["device_id"] = deviceID!
        param["use_yn"] = "Unused"
        param["category"] = "registrationDate"
        param["present"] = 2
        requestPost(requestUrl: "/gift/save", param: param)
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

                var responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

//                    print("회원가입 응답 처리 로직 responseString \n", responseString!)
//                    print("/giftsave data ----> \n", data! as Any)
//                    print("/giftsave response ----> \n", response! as Any)
                    
                    var responseStringA = responseString as! String
                    
//                    print("\(self.LOG_TAG) ", responseStringA.count)
                    
                    if responseStringA.count != 2{
                    
                        responseStringA = responseStringA.replacingOccurrences(of: "]", with: "")
                        responseStringA = responseStringA.replacingOccurrences(of: "[", with: "")
                        
                        print("responseStringA ---- > \n",responseStringA)
                        
                        let arr = responseStringA.components(separatedBy: "},")
    //                    print("arr0 --->", arr[0])
    //                    print("arr1 --->", arr[1])
    //                    print("arr2 --->", arr[2])
                        
                        self.arrRemoveAll()
                        
                        for x in 0...arr.count-1{
                            
                            if x != arr.count-1 {
                                self.dic = self.helper.jsonParser9(stringData: arr[x]+"}" as! String, data1: "seq", data2: "brand", data3: "expiration_period", data4: "img_url", data5: "product_name", data6: "use_yn", data7: "barcode_number", data8: "registration_date", data9: "registrant");
                            }else {
                                self.dic = self.helper.jsonParser9(stringData: arr[x] as! String, data1: "seq", data2: "brand", data3: "expiration_period", data4: "img_url", data5: "product_name", data6: "use_yn", data7: "barcode_number", data8: "registration_date", data9: "registrant");
                            }
                            
                            print("self.dic ----> \n", self.dic)
                            
                            self.brandNameLabelArr.append(self.dic["brand"] as! String)
                            self.productNameLabelArr.append(self.dic["product_name"] as! String)
                            self.barcodeNumberArr.append(self.dic["barcode_number"] as! String)
                            self.expirationPeriodLabelArr.append(self.dic["expiration_period"] as! String)
                            self.useYn.append(self.dic["use_yn"] as! Int)
                            self.registrationDateArr.append(self.dic["registration_date"] as! String)
                            self.cellImageViewArr.append(self.dic["img_url"] as! String)
                            self.seqArr.append(self.dic["seq"] as! Int)
                            self.registrantArr.append(self.dic["registrant"] as! String)
                            
                            self.presentIdArr.append(self.dic["present_id"] as! String)
                            self.presentCheckArr.append(self.dic["present_check"] as! Int)
                            self.presentMessageArr.append(self.dic["present_message"] as! String)
                            
                            
                        }
                    }else {
                        self.arrRemoveAll()
                    }
                    //서버통신후 getGifty
                    DispatchQueue.main.async {
                        self.getGifty()
                    }
                }
                // POST 전송
                task.resume()
    }
    
    
    func getGifty(){
        if brandNameLabelArr.count == 0 &&  expirationPeriodLabelArr.count == 0{
            print("Present2 기프티콘이 존재하지 않음.")
//            label.isHidden = false
            collectionView.isHidden = true
            filterButton.isHidden = true
            
            // 화면 처음그릴때만 add subView
            print("index ", index)
//            if index == 0 {
//                let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 61))
//                label.numberOfLines = 2
                label.numberOfLines = 3
                label.font = UIFont(name: "NanumAmSeuTeReuDam", size: 24)
                label.textColor = .black
                label.center = self.view.center
                label.textAlignment = .center
                label.text = """
                사용한 선물이 없습니다.
                """
                
                self.view.addSubview(label)
//                index += 1
//            }
        }else {
            print("선물 가능한 기프티콘이 존재.")
            collectionView.isHidden = false
            filterButton.isHidden = false
//            label.isHidden = true
            label.removeFromSuperview()
        }
        
//        self.collectionView.reloadData()//이거말고
        //컬렉션뷰 Init
        collectionViewInit()
    }
    
    
    func collectionViewInit(){
        print("\(LOG_TAG) collectionViewInit")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        
        collectionView.reloadData()
    }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        
        flowLayout.minimumInteritemSpacing = 0 // 좌우 margin
        flowLayout.minimumLineSpacing = 10 // 위아래 margin
        
        let halfWidth = UIScreen.main.bounds.width / 2
//        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
//        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 1 + 50)
        flowLayout.itemSize = CGSize(width: halfWidth * 1 , height: halfWidth * 2)
        flowLayout.footerReferenceSize = CGSize(width: halfWidth * 3, height: 70)
        flowLayout.sectionFootersPinToVisibleBounds = true
//        flowLayout.sectionInset = UIEdgeInsets(top:5, left:15, bottom:5, right:7.5);
        
        self.collectionView.collectionViewLayout = flowLayout
    }
    
    func dropDownInit() {
        //드롭다운 btn
        dropDown.dataSource = ["최근 등록순","유효기간 임박순", "상품명순", "교환처 이름순"]
        dropDown.anchorView = filterButton
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        
        //드롭다운 선택
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            print("선택한 아이템 : \(item)")
            print("인덱스 : \(index)")
            
            switch index {
            case 0:
                print("index 0")
                param["category"] = "registrationDate"
                param["present"] = 2
                requestPost(requestUrl: "/gift/save", param: param)
                break
            case 1:
                print("index 1")
                param["category"] = "expirationDate"
                param["present"] = 2
                requestPost(requestUrl: "/gift/save", param: param)
                break
            case 2:
                print("index 2")
                param["category"] = "productName"
                param["present"] = 2
                requestPost(requestUrl: "/gift/save", param: param)
                break
            case 3:
                print("index 3")
                param["category"] = "brandName"
                param["present"] = 2
                requestPost(requestUrl: "/gift/save", param: param)
                break
            default:
                print("default")
            }
            self.dropDown.clearSelection()
            filterButton.setTitle(" "+item, for: .normal)

            collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @IBAction func dropDownAction(_ sender: Any) {
        dropDown.show()
    }
}

extension GiftPresentPage2Controller: UICollectionViewDelegate, UICollectionViewDataSource, presentProtocol2 {
    
    func presentPageReload() {
        print("\(#function)2")
        if UserDefaults.standard.string(forKey: "ID") != nil { //로그인
            //서버 통신후 사용자 혹은 로컬기기 -> DB에 저장되어 있는 값 가져오기
            LoginSetupInit()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return expirationPeriodLabelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    
//        print("collectionView# \(indexPath.row) ", "".getLocalURL()+"/images/\(cellImageViewArr[indexPath.row])")
    
        //  Configure the Cell
        cell.brandNameLabel.text = brandNameLabelArr[indexPath.row]
        cell.productNameLabel.text = productNameLabelArr[indexPath.row]
        cell.expirationPeriodLabel.text = "유효기간 : \(expirationPeriodLabelArr[indexPath.row])"
    
    if useYn[indexPath.row] == 0 {
        cell.useYnBtn.setTitle("사용가능", for: .normal)
        cell.useYnBtn.backgroundColor = .systemGreen
    }else {
        cell.useYnBtn.setTitle("사용불가", for: .normal)
        cell.useYnBtn.backgroundColor = .systemRed
    }
    
    let url = URL(string: "".getLocalURL()+"/images/\(cellImageViewArr[indexPath.row])")
    DispatchQueue.global(qos: .userInteractive).async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
//                    self.imageView.image = UIImage(data: data!)
                cell.cellImageView.image =  UIImage(data: data!)
                cell.cellImageView.contentMode = .scaleAspectFit
//                    self.uiImageArr.append(UIImage(data: data!)!)
//                    self.uiImageArr.append(cell.cellImageView.image!)
            }
    }
        return cell
}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            print("collectionView didSelectItemAt.... ", indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        //click animate
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.backgroundColor = cell.isSelected ? .systemGray2 : .white
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05) {
             cell.backgroundColor = UIColor.white
             
             let vc = self.storyboard?.instantiateViewController(withIdentifier: "GiftDetailVC") as! GiftDetailController
             
             vc.imageUrl = self.cellImageViewArr[indexPath.row]
             vc.barcodeNumber = self.barcodeNumberArr[indexPath.row]
             vc.brandName = self.brandNameLabelArr[indexPath.row]
             vc.productName = self.productNameLabelArr[indexPath.row]
             vc.expirationPeriod = self.expirationPeriodLabelArr[indexPath.row]
             vc.use_yn = self.useYn[indexPath.row]
             vc.registrant = self.registrantArr[indexPath.row]
             vc.registrationDate = self.registrationDateArr[indexPath.row]
             vc.presentMessage = self.presentMessageArr[indexPath.row]
             
             //test
//                vc.uiImage = self.uiImageArr[indexPath.row]
             
             vc.seq = self.seqArr[indexPath.row]
             vc.presentPage = 2
             
             if self.presentIndex{
                 vc.presentIndex = true
                 vc.presentId = self.presentId!
             }
            
            vc.presentProtocol2 = self
             
//                vc.delegate = self // protocol delegate
//                vc.modalPresentationStyle = .fullScreen
//                vc.definesPresentationContext = true
//                vc.modalPresentationStyle = .overCurrentContext
             self.present(vc, animated: true, completion: nil)
         }
     }
    }
}
    
