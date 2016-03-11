//
//  MyTableViewCell.swift
//  swiftme
//
//  Created by George Portillo on 3/7/16.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    let ImageHeight: CGFloat = 200.0
    let OffsetSpeed: CGFloat = 25.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func offset(offset: CGPoint) {
        backgroundImageView.frame = CGRectOffset(backgroundImageView.bounds, offset.x, offset.y)
    }
}