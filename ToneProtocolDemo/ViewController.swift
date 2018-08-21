//
//  ViewController.swift
//  ToneProtocolDemo
//
//  Created by Shalaka Saraf on 07/06/18.
//  Copyright © 2018 Shalaka Saraf. All rights reserved.
//

import UIKit
import ToneFramework
import SwiftIcons
import SlideMenuControllerSwift

class ViewController: UIViewController, LGToneManagerDelegate {
    
    var sortedActions:NSArray = NSArray()

    let kMainToneActionSegue = "HomeToneActionSegue"
    let kClientName: String = "TONE_PROTOCOL_CLIENT_NAME"
    let kHostName: String = "TONE_PROTOCOL_HOST_NAME"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets menu icon
        self.navigationItem.leftBarButtonItem?.setIcon(icon: .fontAwesome(.bars), iconSize: 25)
        
        // Tone Manager initialization
        initToneManager()
    }
    
    func initToneManager(){
        LGToneManager.shared().delegate = self
        
        LGToneManager.shared().handleNotifications(inFramework: false)
        LGToneManager.shared().shouldIgnoreSameSequence(inFramework: false)
        let clientName: String = Bundle.main.infoDictionary![kClientName] as! String
        let hostName: String = Bundle.main.infoDictionary![kHostName] as! String
        LGToneManager.shared().configureManagerClientName(clientName, hostName: hostName)
    }
    
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Starts recording and listening for tone
        LGToneManager.shared().start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }

    func actionListUpdated(_ actions: [Any]!) {
        // Moves to ToneActionViewController where it displays the image in URL
        sortedActions = actions as NSArray
        if self.presentedViewController is ToneActionViewController {
            let action = sortedActions[0] as! LGAction
            (self.presentedViewController as! ToneActionViewController).loadUrl(action: action)
        }
        else {
            self.performSegue(withIdentifier: "HomeToneActionSegue", sender: self)
        }
    }
    
    func notificationTapped() {
        // Performs an action when notification is tapped
        print("Notfication tapped")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMainToneActionSegue {
            let toneActionViewController = segue.destination as! ToneActionViewController
            toneActionViewController.action = sortedActions[0] as! LGAction
        }
    }
}

