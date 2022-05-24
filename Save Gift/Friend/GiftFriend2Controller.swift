//
//  GiftFriend2Controller.swift
//  Save Gift
//
//  Created by mac on 2022/05/24.
//

import Foundation
import UIKit

class GiftFriend2Controller : UIViewController {
    
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    let topLabel = UILabel()
    let topTableView = UITableView()
    let bottomLabel = UILabel()
    let bottomTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("GiftFriend2Controller \(#function)")
        
        topLabelSetUp()
        topTableViewSetUp()
    }
    
    func topLabelSetUp(){
//        topLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 21))
        topLabel.textAlignment = .center
        topLabel.text = "[친구 요청]"
        topLabel.textColor = .systemGray2
        topLabel.backgroundColor = .systemIndigo
        self.scrollView.addSubview(topLabel)
        
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 30).isActive = true
        topLabel.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 15).isActive = true
    }
    
    func topTableViewSetUp(){
        print("topTableView ~~~~~~~ \(#line)")
        
        topTableView.isScrollEnabled = false
        topTableView.dataSource = self
        topTableView.delegate = self
        topTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.scrollView.addSubview(topTableView)
        
        topTableView.translatesAutoresizingMaskIntoConstraints = false
        topTableView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 20).isActive = true
        topTableView.leftAnchor.constraint(equalTo: uiView.leftAnchor, constant: 0).isActive = true
        topTableView.rightAnchor.constraint(equalTo: uiView.rightAnchor, constant: 0).isActive = true
        
        topTableView.backgroundColor = .blue
    }
    
}

extension GiftFriend2Controller : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("topTableView ~~~~~~~ \(#line)")
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
