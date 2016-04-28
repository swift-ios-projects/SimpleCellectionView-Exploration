//
//  SectionHeaderView.swift
//  Papers
//
//  Created by Robert Byrne on 2016-04-27.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class SectionHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
}
