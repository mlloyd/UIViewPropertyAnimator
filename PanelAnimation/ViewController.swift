//
//  ViewController.swift
//  AnimationTest
//
//  Created by Martin Lloyd on 05/10/2016.
//  Copyright © 2016 Thomson Reuters. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var box: UIView!
    var panGestureRecognizer: UIPanGestureRecognizer!
    var animator: UIViewPropertyAnimator!
    var forwards = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        self.view.addGestureRecognizer(self.panGestureRecognizer)
        
        self.box = UIView(frame: self.view.bounds)
        self.box.backgroundColor = UIColor.yellow
        self.view.addSubview(self.box)
        
        self.box.layer.shadowColor = UIColor.black.cgColor
        self.box.layer.shadowOffset = CGSize(width: 0, height: 5.0)
        self.box.layer.shadowOpacity = 0.25
        self.box.layer.shadowRadius = 1.0
        
//        http://cubic-bezier.com/#.29,-0.58,.47,1.37
        self.animator = UIViewPropertyAnimator(duration: 1.0, controlPoint1: CGPoint(x: 0.29, y: -0.58), controlPoint2: CGPoint(x: 0.47, y: 1.37), animations: nil)
    }

    func pan(gestureRecognizer: UIPanGestureRecognizer) {
        
        switch gestureRecognizer.state {
        case .began:
            
            forwards ?
                animator.addAnimations { [weak self] in
                    self?.box.frame.origin.y = -(self!.box.frame.size.height - 80)
                }:
                animator.addAnimations { [weak self] in
                    self?.box.frame.origin.y = 0
                }
            
            animator.addCompletion({ [weak self] (position: UIViewAnimatingPosition) in
                guard position != .current else { return }
                self?.panGestureRecognizer.isEnabled = true
            })
            
            animator.isReversed = false
            animator.pauseAnimation()
                        
        case .changed:
            let translation = gestureRecognizer.translation(in: self.view)
            let translationY = forwards ? -translation.y: translation.y
            let percentage = CGFloat(fmaxf(0,Float(translationY / self.box.bounds.size.height)))
            
            animator.fractionComplete = percentage
//            print(percentage)
        
        case .ended, .cancelled:
            self.panGestureRecognizer.isEnabled = false
            
            if animator.fractionComplete < 0.5 ||
                gestureRecognizer.state == .cancelled {
                
                animator.isReversed = true
            }
            else {
                forwards = !forwards
            }
            
            animator.startAnimation()
            
            default:
            break
        }
    }
}
