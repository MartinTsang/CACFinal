//
//  roundTableViewCell.swift
//  CACproject
//
//  Created by Timothy Park on 10/18/17.
//  Copyright © 2017 Timothy Park. All rights reserved.
//

import UIKit

class roundTableViewCell: UITableViewCell {
    
    let view = UIView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        // Set the width of the cell
        super.layoutSubviews()
        self.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
    }

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "cell")
    }
 
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        background.frame = CGRectMake(0, padding, frame.width, frame.height - 2 * padding)
//        typeLabel.frame = CGRectMake(padding, (frame.height - 25)/2, 40, 25)
//        priceLabel.frame = CGRectMake(frame.width - 100, padding, 100, frame.height - 2 * padding)
//        nameLabel.frame = CGRectMake(CGRectGetMaxX(typeLabel.frame) + 10, 0, frame.width - priceLabel.frame.width - (CGRectGetMaxX(typeLabel.frame) + 10), frame.height)
//    }
    
/*
    func setMainBackground() {
        
        self.mainBackground.layer.cornerRadius = 8
        self.mainBackground.layer.masksToBounds = true
    }
    
    func setShadowLayer() {
        self.shadowLayer.layer.masksToBounds = false
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.23
        self.shadowLayer.layer.shadowRadius = 4

    }

 */
 
}
