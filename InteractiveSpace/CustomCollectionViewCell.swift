//
//  CustomCollectionViewCell.swift
//  InteractiveSpace
//
//  Created by Michael Babiy on 12/7/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        didSet {
            self.imageView.image = self.image
        }
    }
    
}
