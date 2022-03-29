//
//  CollectionViewTopCell.swift
//  Save Gift
//
//  Created by mac on 2022/03/24.
//

import UIKit

protocol PagingTabbarDelegate {
    func scrollToIndex(to index: Int)
}

class CollectionViewTopCell: UICollectionViewCell {
    
    var delegate: PagingTabbarDelegate?

    @IBOutlet weak var viewPagerLabel: UILabel!
    @IBOutlet weak var menuUnderBar: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                viewPagerLabel.textColor = .red
                viewPagerLabel.font = .boldSystemFont(ofSize: 14)
                self.menuUnderBar.layer.borderWidth = 1.3
                print("viewPagerLabel.text ", viewPagerLabel.text!)
                switch viewPagerLabel.text! {
                case "All":
                    print("All...")
                    break
                case "Unused":
                    print("Unused...")
                    break
                case "Used":
                    print("Used...")
                    break
                default:
                    print("default")
                }
            } else {
                viewPagerLabel.textColor = .lightGray
                viewPagerLabel.font = .boldSystemFont(ofSize: 13)
                self.menuUnderBar.layer.borderWidth = 0.0
            }
                
            delegate?.scrollToIndex(to: 3)
        }
        
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.menuUnderBar.layoutIfNeeded()
                self.menuUnderBar.layer.borderColor = UIColor.red.cgColor
//                self.menuUnderBar.layer.borderWidth = 1.0
                self.menuUnderBar.alpha = self.isSelected ? 1 : 0
            }, completion: nil)
        }
    }
    
    override var isHighlighted: Bool {
            didSet {
                UIView.animate(withDuration: 1.0, delay: 0, options: .curveEaseOut, animations: {
                    self.menuUnderBar.layoutIfNeeded()
                    self.menuUnderBar.layer.borderColor = UIColor.red.cgColor
                    self.menuUnderBar.layer.borderWidth = 1.0
                    self.menuUnderBar.alpha = self.isSelected ? 1 : 0
                }, completion: nil)
            }
    }
    
    
    override func prepareForReuse() {
        isSelected = false
        print("prepareForReuse")
    }

}


