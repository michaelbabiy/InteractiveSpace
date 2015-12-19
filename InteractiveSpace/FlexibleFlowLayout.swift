//
//  FlexibleFlowLayout.swift
//  InteractiveSpace
//
//  Created by Michael Babiy on 12/7/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class FlexibleFlowLayout: UICollectionViewFlowLayout {
    
    let frame: CGRect
    let columns: Int
    let interitemSpacing: CGFloat
    let lineSpacing: CGFloat
    let interitemSpacingOffset: CGFloat
    
    init(frame: CGRect = UIScreen.mainScreen().bounds, colums: Int = 3, interitemSpacing: CGFloat = 2.0, lineSpacing: CGFloat = 2.0) {
        self.frame = frame
        self.columns = colums
        self.interitemSpacing = interitemSpacing
        self.lineSpacing = lineSpacing
        self.interitemSpacingOffset = (self.interitemSpacing * CGFloat(self.columns - 1))
        
        super.init()
        self.setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        let availableWidth = CGRectGetWidth(self.frame) - self.interitemSpacingOffset
        let itemWidth = availableWidth / CGFloat(self.columns)
        self.minimumInteritemSpacing = self.interitemSpacing
        self.minimumLineSpacing = self.lineSpacing
        self.itemSize = CGSize(width: itemWidth, height: itemWidth)
    }
    
}
