//
//  POICell.swift
//  SmallPink
//
//  Created by yalan on 2022/4/13.
//

import UIKit

class POICell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var poi = ["", ""]{
        didSet{
            titleLabel.text = poi[0]
            addressLabel.text = poi[1]
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
