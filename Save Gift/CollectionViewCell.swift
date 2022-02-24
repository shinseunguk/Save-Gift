//
//  CollectionViewCell.swift
//  Save Gift
//
//  Created by ukBook on 2022/02/20.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandNameLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var expirationPeriodLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("CollectionViewCell awakeFromNib")
    }

}
