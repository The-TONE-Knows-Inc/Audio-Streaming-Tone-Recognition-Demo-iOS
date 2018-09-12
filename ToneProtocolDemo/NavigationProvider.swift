//
//  NavigationProvider.swift
//  ToneProtocolDemo
//
//  Created by Nikhil Gaonkar on 11/09/18.
//  Copyright © 2018 Tone Protocol. All rights reserved.
//

import Foundation
import UIKit
class NavigationProvider: NavigationProviderProtocol {
    
    var homeViewController : UIViewController?;
    var toneListTableViewController : UIViewController?;
    
    func viewControllerForMenuItem(menuItem: MenuItem)-> UIViewController? {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch menuItem {
        case .home:
            if(homeViewController == nil){
                homeViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController");
            }
            return homeViewController
            
        case .inbox:
            if(toneListTableViewController == nil){
                toneListTableViewController = storyboard.instantiateViewController(withIdentifier: "ToneListTableViewController");
            }
            return toneListTableViewController
        }
    }
}
