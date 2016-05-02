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
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    var editing: Bool = false {
        didSet {
            captionLabel.hidden = editing
            checkImageView.hidden = !editing
        }
    }
    
    override var selected: Bool {
        didSet {
            if editing {
                checkImageView.image = UIImage(named: selected ? "Checked" : "Unchecked")
            }
        }
    }
    
    var paper: Paper? {
        didSet {
            if let paper = paper {
                paperImageView.image = UIImage(named: paper.imageName)
                captionLabel.text = paper.caption
            }
        }
    }
}
