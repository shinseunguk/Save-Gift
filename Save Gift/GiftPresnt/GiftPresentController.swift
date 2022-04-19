//
//  GiftPresent.swift
//  Save Gift
//
//  Created by ukBook on 2021/12/25.
//  기프티콘 선물하깈

import Foundation
import UIKit
import Tabman
import Pageboy

class GiftPresentController : TabmanViewController{
    @IBOutlet weak var tempView: UIView!
    
    private var viewControllers: Array<UIViewController> = []
    
    var viewPagerArr = ["선물함   0", "선물 가능한 기프티콘   3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GiftPresentController")
     
        setTabMan()
    }
    
    func setTabMan() {
        let AllVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Present1VC") as! GiftPresentPage1Controller
        let UnusedVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Present2VC") as! GiftPresentPage2Controller
                    
        viewControllers.append(AllVC)
        viewControllers.append(UnusedVC)
        
        self.dataSource = self

        // Create bar
        let bar = TMBar.ButtonBar()
//        let bar = TMBar.TabBar()
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.buttons.customize { (button) in
            button.tintColor = UIColor.systemGray2 // 선택 안되어 있을 때
            button.selectedTintColor = .systemBlue // 선택 되어 있을 때
            button.font = UIFont.systemFont(ofSize: 13)
        }
        // 인디케이터 조정
        bar.indicator.weight = .light
        bar.indicator.tintColor = .systemBlue
        bar.indicator.overscrollBehavior = .compress
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 20 // 버튼 사이 간격
    
        bar.layout.transitionStyle = .snap // Customize

        // Add to view
        addBar(bar, dataSource: self, at: .custom(view: tempView, layout: nil)) // .custom을 통해 원하는 뷰에 삽입함. BarLocatio https://github.com/uias/Tabman/blob/main/Sources/Tabman/TabmanViewController.swift#L27-L32
    }
}

extension GiftPresentController: PageboyViewControllerDataSource, TMBarDataSource{
    
    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        
            // MARK: - Tab 안 글씨들
            switch index {
            case 0:
                return TMBarItem(title: viewPagerArr[0])
            case 1:
                return TMBarItem(title: viewPagerArr[1])
            default:
                let title = "Page \(index)"
                return TMBarItem(title: title)
            }

        }
        
        func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewPagerArr.count
        }
        
        func viewController(for pageboyViewController: PageboyViewController, at index: PageboyViewController.PageIndex) -> UIViewController? {
            return viewControllers[index]
        }
        
        func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
            return nil
        }
    
}
