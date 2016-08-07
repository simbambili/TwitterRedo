//
//  HamburgerViewController.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {


    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewLeftMarginConstraint: NSLayoutConstraint!

    
    var originalContentViewLeftMargin: CGFloat!
    var maxContentViewTranslation: CGFloat!
    var menuViewController: UIViewController! {
        didSet{
            self.view.layoutIfNeeded() // prevent menuView from being nil as it calls viewDidLoad
            menuViewController.willMoveToParentViewController(self)
            self.menuView.addSubview(menuViewController.view)
            menuViewController.didMoveToParentViewController(self)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet(oldContentViewController){
            self.view.layoutIfNeeded() // prevent menuView from being nil as it calls viewDidLoad
            if (oldContentViewController != nil){
                oldContentViewController.willMoveToParentViewController(nil)
                oldContentViewController.view.removeFromSuperview()
                oldContentViewController.didMoveToParentViewController(nil)
            }
            contentViewController.willMoveToParentViewController(self)
            self.contentView.addSubview(contentViewController.view)
            contentViewController.didMoveToParentViewController(self)
            self.closeMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.maxContentViewTranslation = view.frame.size.width - 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func closeMenu() {
        UIView.animateWithDuration(0.3) { 
            self.contentViewLeftMarginConstraint.constant = 0.0
            self.view.layoutIfNeeded()
        }
    }

    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            self.originalContentViewLeftMargin = self.contentViewLeftMarginConstraint.constant
            //print("originalLeftMargin: \(self.originalContentViewLeftMargin)")
        } else if sender.state == UIGestureRecognizerState.Changed {
            self.contentViewLeftMarginConstraint.constant = self.originalContentViewLeftMargin + translation.x
        } else if sender.state == UIGestureRecognizerState.Ended {
            UIView.animateWithDuration(0.4, animations: {
                //print("velocity.x: \(velocity.x)")
                if (velocity.x > 0){
                    //print("Positive velocity")
                    self.contentViewLeftMarginConstraint.constant = self.maxContentViewTranslation
                } else {
                    //print("Negative velocity")
                    self.closeMenu()
                }
                self.view.layoutIfNeeded()
            })
            
        }
    }
}
