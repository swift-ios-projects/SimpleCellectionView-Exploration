//
//  MasterViewController.swift
//  Papers
//
//  Created by Robert Byrne on 2016-04-16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import UIKit

class MasterViewController: UICollectionViewController {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private var papersDataSource = PapersDataSource()
    
    private var snapshot: UIView?
    private var sourceIndexPath: NSIndexPath?
    
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.toolbarHidden = true
        
        // add edit button to top bar
        navigationItem.leftBarButtonItem = editButtonItem()
        
        // Set item size to one third of the width of the screen
        let width = CGRectGetWidth(collectionView!.frame) / 3
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        
        // add the long press gesture recognizer to allow moving cells
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        collectionView!.addGestureRecognizer(longPressGestureRecognizer)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "MasterToDetail" {
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.paper = sender as? Paper
        }
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.enabled = !editing
        collectionView!.allowsMultipleSelection = editing
        let indexPaths = collectionView!.indexPathsForVisibleItems() as [NSIndexPath]
        for indexPath in indexPaths {
            collectionView!.deselectItemAtIndexPath(indexPath, animated: false)
            let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PaperCell
            cell.editing = editing
        }
        
        if !editing {
            navigationController!.setToolbarHidden(true, animated: true)
        }
        
    }
    
    // MARK: MasterViewController
    
    @IBAction func addButtonTapped(sender: UIBarButtonItem) {
        
        let indexPath = papersDataSource.indexPathForNewRandomPaper()
        collectionView!.insertItemsAtIndexPaths([indexPath])
        
        // Setting up the PapersFlowLayout created in the Layouts folder
        let layout = collectionViewLayout as! PapersFlowLayout
        layout.appearingIndexPath = indexPath
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.65, initialSpringVelocity: 0.0, options: .CurveEaseInOut, animations: { () -> Void
            in
            let indexPath = self.papersDataSource.indexPathForNewRandomPaper()
            self.collectionView!.insertItemsAtIndexPaths([indexPath])
            
            }, completion:  { (finished: Bool) -> Void in
                
                layout.appearingIndexPath = nil
                
        })
        
    }
    
    @IBAction func deleteButtonTapped(sender: UIBarButtonItem) {
        
        let indexPaths = collectionView!.indexPathsForSelectedItems()! as [NSIndexPath]
        
        let layout = collectionViewLayout as! PapersFlowLayout
        layout.disappearingItemsIndexPaths = indexPaths
        
        papersDataSource.deleteItemsAtIndexPaths(indexPaths)
        UIView.animateWithDuration(0.65, delay: 0.0, options: .CurveEaseOut, animations: { () -> Void in
            self.collectionView!.deleteItemsAtIndexPaths(indexPaths)
            
        }) { (finished: Bool) -> Void in
            layout.disappearingItemsIndexPaths = nil
        }
    }
    
    private func updateSnapshotView(center: CGPoint, transform: CGAffineTransform, alpha: CGFloat) {
        if let snapshot = snapshot {
            snapshot.center = center
            snapshot.transform = transform
            snapshot.alpha = alpha
        }
    }
    
    func handleLongPress(recognizer: UILongPressGestureRecognizer ) {
        if editing {
            return
        }
        
        let location = recognizer.locationInView(collectionView)
        let indexPath = collectionView!.indexPathForItemAtPoint(location)
        
        switch recognizer.state {
        case .Began:
            if let indexPath = indexPath {
                sourceIndexPath = indexPath
                let cell = collectionView!.cellForItemAtIndexPath(indexPath) as! PaperCell
                snapshot = cell.snapshot
                updateSnapshotView(cell.center, transform: cell.transform, alpha: cell.alpha)
                collectionView!.addSubview(snapshot!)
                UIView.animateWithDuration(0.25, animations: { () -> Void in
                    self.updateSnapshotView(cell.center, transform: CGAffineTransformMakeScale(1.05, 1.05), alpha: 0.95)
                    cell.moving = true
                })
            }
            
            
        case .Changed:
            self.snapshot!.center = location
            if let indexPath = indexPath {
                papersDataSource.movePaperAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                collectionView!.moveItemAtIndexPath(sourceIndexPath!, toIndexPath: indexPath)
                sourceIndexPath = indexPath
            }
            
            
        default:
            let cell = collectionView!.cellForItemAtIndexPath(sourceIndexPath!) as! PaperCell
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.updateSnapshotView(cell.center, transform: CGAffineTransformIdentity, alpha: 0.0)
                cell.moving = false
                }, completion:  { (finished: Bool) -> Void in
                    self.snapshot!.removeFromSuperview()
                    self.snapshot = nil
            })
        }
    }
    
    
    
    // MARK: CollectionViewDataSource
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return papersDataSource.numberOfSections
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return papersDataSource.numberOfPapersInSection(section)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PaperCell", forIndexPath: indexPath) as! PaperCell
        if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
            cell.paper = paper
            cell.editing = editing
        }
        return cell
        
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let sectionHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionHeaderView
        if let title = papersDataSource.titleForSectionAtIndexPath(indexPath) {
            sectionHeaderView.title = title
            sectionHeaderView.icon = UIImage(named: title)
        }
        return sectionHeaderView
    }
    
    // MARK: UICollectionViewDelegate
    
    // Click on a cell to perform the MasterToDetail segue
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if !editing {
            if let paper = papersDataSource.paperForItemAtIndexPath(indexPath) {
                performSegueWithIdentifier("MasterToDetail", sender: paper)
            }
        } else {
            navigationController!.setToolbarHidden(false, animated: true)
            
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editing {
            if collectionView.indexPathsForSelectedItems()!.count == 0 {
                navigationController!.setToolbarHidden(true, animated: true)
            }
        }
    }
    
}
