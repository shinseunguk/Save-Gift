//
//  CollectionViewTopCell.swift
//  Save Gift
//
//  Created by mac on 2022/03/24.
//  https://eastbyeden.tistory.com/11
// github.com/rising-jun/BasicUI

import UIKit

class CollectionViewTopCell: UICollectionViewCell {
    
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
//                print("viewPagerLabel.text ", viewPagerLabel.text!)
                switch viewPagerLabel.text! {
                case "All":
//                    print("All...")
//                    self.scrollToIndexFunc(page: 0)
                    break
                case "Unused":
//                    print("Unused...")
//                    self.scrollToIndexFunc(page: 1)
                    break
                case "Used":
//                    print("Used...")
//                    self.scrollToIndexFunc(page: 2)
                    break
                default:
                    print("default")
                }
            } else {
                viewPagerLabel.textColor = .lightGray
                viewPagerLabel.font = .boldSystemFont(ofSize: 13)
                self.menuUnderBar.layer.borderWidth = 0.0
            }
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


