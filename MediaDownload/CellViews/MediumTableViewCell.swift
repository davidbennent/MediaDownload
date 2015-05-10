//
//  MediumTableViewCell.swift
//  MediaDownload
//
//  Created by David Bennet on 2/11/15.
//  Copyright (c) 2015 David Bennet. All rights reserved.
//

import UIKit

class MediumTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: AsyncImageView!
    
    // MARK: Override methods

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
