//
//  ViewController.swift
//  InteractiveSpace
//
//  Created by Michael Babiy on 12/7/15.
//  Copyright © 2015 Michael Babiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let smallLayout = FlexibleFlowLayout(colums: 3)
    let mediumLayout = FlexibleFlowLayout(colums: 2)
    let largeLayout = FlexibleFlowLayout(colums: 1)
    var transitionLayout: UICollectionViewTransitionLayout?
    
    var postPinchTransitionCompleted = true
    var pinchDirectionDetermined = false
    var initialPinchScale: CGFloat = 0.0
    var pinchPoint: CGPoint = CGPoint(x: 0, y: 0)
    
    var datasource = [UIImage]() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()
        self.setupSource()
        self.setupPinchGestureRecognizer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupAppearance() {
        self.collectionView.collectionViewLayout = self.smallLayout
    }
    
    func setupSource() {
        for i in 0...7 {
            guard let image = UIImage(named: "\(i)") else {return}
            self.datasource.append(image)
        }
    }
    
    func setupPinchGestureRecognizer() {
        self.collectionView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: "handlePinchGestureRecognizer:"))
    }
    
    func handlePinchGestureRecognizer(gesture: UIPinchGestureRecognizer) {
        if gesture.velocity < 0 && self.collectionView.collectionViewLayout == self.smallLayout { return }
        
        if self.postPinchTransitionCompleted {
            
            // ... Gesture Began ... //
            if (gesture.state == .Began) {
                self.initialPinchScale = gesture.scale
                self.pinchDirectionDetermined = false
            }
            
            if (gesture.state == .Changed) && self.pinchDirectionDetermined == false {
                
                self.pinchDirectionDetermined = true
                self.pinchPoint = gesture.locationInView(gesture.view)
                
                let endLayout = self.nextLayoutForVelocity(gesture.velocity)
                
                if endLayout != self.collectionView.collectionViewLayout {
                    self.transitionLayout = self.collectionView.startInteractiveTransitionToCollectionViewLayout(endLayout, completion: { (completed, finished) -> Void in
                        if completed {
                            self.transitionLayout = nil
                            self.postPinchTransitionCompleted = true
                        }
                    })
                }
            }
            
            guard let transitionLayout = self.transitionLayout else {return}
            transitionLayout.transitionProgress = fabs(self.initialPinchScale - gesture.scale) / self.initialPinchScale
            
            // ... Gesture Ended ... //
            if (gesture.state == .Ended) {
                transitionLayout.transitionProgress > 0.25 ? self.collectionView.finishInteractiveTransition() : self.collectionView.cancelInteractiveTransition()
                self.postPinchTransitionCompleted = false
            }
        }
    }
    
    func nextLayoutForVelocity(velocity: CGFloat) -> UICollectionViewFlowLayout {
        if velocity > 0 {
            if self.collectionView.collectionViewLayout == self.smallLayout {
                return self.mediumLayout;
            } else if self.collectionView.collectionViewLayout == self.mediumLayout {
                return self.largeLayout;
            } else {
                return self.largeLayout;
            }
        } else {
            if self.collectionView.collectionViewLayout == self.largeLayout {
                return self.mediumLayout;
            } else {
                return self.smallLayout;
            }
        }
    }
    
    // MARK: UICollectionView
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomCollectionViewCell", forIndexPath: indexPath) as! CustomCollectionViewCell
        customCell.image = self.datasource[indexPath.row]
        return customCell
    }


}
