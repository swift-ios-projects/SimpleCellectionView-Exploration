//
//  PaperCell.swift
//  Papers
//
//  Created by Robert Byrne on 2016-04-27.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PaperCell: UICollectionViewCell {
    
    @IBOutlet weak var paperImageView: UIImageView!
    
    var paper: Paper? {
        didSet {
            if let paper = paper {
                paperImageView.image = UIImage(named: paper.imageName)
            }
        }
    }
}
