//
//  MenuViewController.swift
//  ToneProtocolDemo
//
//  Created by Shalaka Saraf on 08/06/18.
//  Copyright © 2018 Shalaka Saraf. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var menuItemTitles = ["Home", "Inbox"]
    let kRowHeightNormal:CGFloat = 60
    let kSectionHeaderHeightNormal:CGFloat = 60
    
    @IBOutlet var menuTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuTableView.delegate = self
        menuTableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItemTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell") as! MenuItemTableViewCell
        cell.menuItem.text = menuItemTitles[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if let viewController = (appDelegate.navigationProvider?.viewControllerForMenuItem(menuItem: menuItemForIndex(index: indexPath.row))){
            self.slideMenuController()?.changeMainViewController(viewController, close: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kRowHeightNormal
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kSectionHeaderHeightNormal
    }
}

func menuItemForIndex(index: Int)->MenuItem{
    switch index {
        case 0:
            return .home
        case 1:
            return .inbox
        default:
            return .home
    }
}

class MenuItemTableViewCell: UITableViewCell {

    @IBOutlet weak var menuItem: UILabel!
    
}
