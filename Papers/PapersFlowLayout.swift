//
//  PapersFlowLayout.swift
//  Papers
//
//  Created by Robert Byrne on 2016-04-30.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class PapersFlowLayout: UICollectionViewFlowLayout {
    
    var appearingIndexPath: NSIndexPath?
    var disappearingItemsIndexPaths: [NSIndexPath]?
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        // returns the attributes that would normally be passed by UICollectionViewFlowLayout
        let attributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        
        if let indexPath = appearingIndexPath {
            if let attributes = attributes {
                if indexPath == itemIndexPath {
                    // Scale and position the cell accordingly
                    attributes.alpha = 1.0
                    attributes.center = CGPoint(x: CGRectGetWidth(collectionView!.frame) - 23.5, y: -24.5)
                    attributes.transform = CGAffineTransformMakeScale(0.15, 0.15)
                    // lets the new cell be seen above the rest!
                    attributes.zIndex = 99
                }
            }
        }
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        
        if let indexPaths = disappearingItemsIndexPaths {
            if let attributes = attributes {
                if indexPaths.contains(itemIndexPath) {
                    attributes.alpha = 1.0
                    attributes.transform = CGAffineTransformMakeScale(0.1, 0.1)
                    attributes.zIndex = -1
                }
            }
        }
        return attributes
    }
}
