//
//  SettingHowToUseController.swift
//  Save Gift
//
//  Created by ukBook on 2022/01/13.
//

import Foundation
import UIKit
import KakaoSDKCommon

class SettingHowToUseController : UIViewController {
    
    let faqTableView = UITableView()
    @IBOutlet weak var faqLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var uiView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = .systemBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.init(displayP3Red: 242/255, green: 242/255, blue: 247/255, alpha: 1)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationItem.title = "기프티콘 사용법"
        
        tableViewSetUp()
    }
    
    func tableViewSetUp(){
        faqTableView.isScrollEnabled = false
        faqTableView.dataSource = self
        self.scrollView.addSubview(faqTableView)
        
        faqTableView.register(UINib(nibName: "SettingHowToUseCell", bundle: nil), forCellReuseIdentifier: "SettingHowToUseCell")
        
        faqTableView.translatesAutoresizingMaskIntoConstraints = false
        faqTableView.topAnchor.constraint(equalTo: faqLabel.bottomAnchor, constant: 20).isActive = true
        faqTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 20).isActive = true
        faqTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: -20).isActive = true
        
        faqTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
}

extension SettingHowToUseController : UITableViewDelegate, UITableViewDataSource {
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(20)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingHowToUseCell", for: indexPath) as! SettingHowToUseCell
        cell.leftLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    
}
