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
    
    enum PlayerState {
        case playing
        case stopped
    }
    
    var playerState = PlayerState.stopped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor.black
        
        // Sets menu icon
        //self.navigationItem.leftBarButtonItem?.setIcon(icon: .fontAwesome(.bars), iconSize: 25, color: UIColor.white)
        
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
        self.performSegue(withIdentifier: "HomeToneActionSegue", sender: self)
    }
    
    func notificationTapped() {
        // Performs an action when notification is tapped
        print("Notfication tapped")
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if playerState == .playing{
            playerState = .stopped
            sender.setImage(UIImage(named: "play"), for: UIControlState.normal)
        }else{
            playerState = .playing
            sender.setImage(UIImage(named: "stop"), for: UIControlState.normal)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMainToneActionSegue {
            let toneActionViewController = segue.destination as! ToneActionViewController
            toneActionViewController.action = sortedActions[0] as! LGAction
        }
    }
}

