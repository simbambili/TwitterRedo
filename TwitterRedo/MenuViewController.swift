//
//  MenuViewController.swift
//  TwitterRedo
//
//  Created by Shaz Rajput on 8/6/16.
//  Copyright © 2016 Shaz Rajput. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var viewControllers: [UIViewController] = []
    private var profileNavigationController: UIViewController!
    private var homeTimelineNavigationController: UIViewController!
    private var mentionsNavigationController: UIViewController!
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.profileNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        self.homeTimelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("HomeTimelineNavigationController")
        self.mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        
        self.viewControllers.append(self.profileNavigationController)
        self.viewControllers.append(self.homeTimelineNavigationController)
        self.viewControllers.append(self.mentionsNavigationController)
        
        self.hamburgerViewController.contentViewController = self.profileNavigationController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewControllers.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("Selected MenuCell at index: \(indexPath.row)")
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.hamburgerViewController.contentViewController = self.viewControllers[indexPath.row]
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let titles = ["Profile", "Home Timeline", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
