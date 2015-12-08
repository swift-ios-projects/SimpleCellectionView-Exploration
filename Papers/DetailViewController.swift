//
//  DetailViewController.swift
//  Wallpapers
//
//  Created by Robert Byrne
//  lenarob.com
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  
  var paper: Paper?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    if let paper = paper {
      navigationItem.title = paper.caption
      imageView.image = UIImage(named: paper.imageName)
    }
  }
  
}
