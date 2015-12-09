//
//  PaperCollectionViewCell.swift
//  SimpleCollectionView
//
//  Created by Robert Byrne on 2015-12-08.
//  Copyright © 2015 leanrob. All rights reserved.
//

import UIKit

class PaperCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var paperImageView: UIImageView!
    
    var paper: Paper? {
        didSet {
            if let paper = paper {
                 paperImageView.image = UIImage(named: paper.imageName)
            }
        }
    }
}
