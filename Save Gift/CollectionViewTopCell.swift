//
//  CollectionViewTopCell.swift
//  Save Gift
//
//  Created by mac on 2022/03/24.
//

import UIKit

class CollectionViewTopCell: UICollectionViewCell {

    @IBOutlet weak var viewPagerLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                viewPagerLabel.textColor = .red
                
            } else {
                viewPagerLabel.textColor = .lightGray
            }
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
    }

}


