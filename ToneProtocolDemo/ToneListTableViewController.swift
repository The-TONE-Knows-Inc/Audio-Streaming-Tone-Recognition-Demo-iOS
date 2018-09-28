//
//  ToneListTableViewController.swift
//  ToneProtocolDemo
//
//  Created by Shalaka Saraf on 07/06/18.
//  Copyright © 2018 Shalaka Saraf. All rights reserved.
//

import UIKit
import ToneFramework
import SwiftIcons
import SlideMenuControllerSwift

class ToneListTableViewController: UITableViewController {
    
    var sortedActions:NSArray = NSArray()
    var selectedAction: LGAction = LGAction()
    
    let kToneListToneActionSegue = "ToneListToneActionSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        //create a new button
        let button = UIButton.init(type: .custom)
        //set image for button
        button.setImage(UIImage(named: "icon_menu.png"), for: UIControlState.normal)
        //add function for button
        button.addTarget(self, action: #selector(ViewController.didPressMenuButton), for: UIControlEvents.touchUpInside)
        //set frame
        button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        */
        
        // Sets menu icon
        self.navigationItem.leftBarButtonItem?.setIcon(icon: .fontAwesome(.bars), iconSize: 25, color: UIColor.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Fetches actions
        sortedActions = LGToneManager.shared().getSortedActions(false) as NSArray
    }
    
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        slideMenuController()?.openLeft()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedActions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "toneActionCell", for: indexPath) as! toneActionCell
        let action: LGAction = sortedActions.object(at: indexPath.row) as! LGAction
        cell.actionLinkImage.setIcon(icon: .fontAwesome(.link))
        if action.actionType == LGActionType.actionTypeImage {
            cell.actionLinkText.text = "Open Image"
        }
        else if action.actionType == LGActionType.actionTypeUrl {
            cell.actionLinkText.text = "Open Link"
        }else if action.actionType == LGActionType.actionTypeEmail {
            cell.actionLinkText.text = "Open Email"
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAction = sortedActions.object(at: indexPath.row) as! LGAction
        // Displays image in web view and add close button
        if selectedAction.actionType == LGActionType.actionTypeEmail {
            if let url = URL(string: selectedAction.actionURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else {
            self.performSegue(withIdentifier: "ToneListToneActionSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kToneListToneActionSegue {
            let toneActionViewController = segue.destination as! ToneActionViewController
            toneActionViewController.action = selectedAction
        }
    }
}

class toneActionCell: UITableViewCell {
    @IBOutlet weak var actionLinkImage: UIImageView!
    @IBOutlet weak var actionLinkText: UILabel!
}
