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
        
        // Sets menu icon
        self.navigationItem.leftBarButtonItem?.setIcon(icon: .fontAwesome(.bars), iconSize: 25)
        
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
        }
        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAction = sortedActions.object(at: indexPath.row) as! LGAction
        // Displays image in web view and add close button
        print(selectedAction.actionURL)
        self.performSegue(withIdentifier: "ToneListToneActionSegue", sender: self)
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
