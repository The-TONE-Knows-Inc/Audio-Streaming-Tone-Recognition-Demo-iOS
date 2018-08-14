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
    var player: AVPlayer?
    let defaultFeedURL = URL(string: "http://192.168.10.21:8888/tone/AirKast_SubwayRadio_15K_XXXX_ZZZZ_R22_W_PreRoll_44.1k.mp3")
    
    @IBOutlet weak var buttonPlayPause: UIButton!
    
    enum PlayerState {
        case playing
        case stopped
    }
    
    enum AudioReceiverType {
        case mic
        case audioStream
    }
    
    var playerState = PlayerState.stopped
    let audioReceiverType = AudioReceiverType.audioStream
    var loopAudio: Bool = false
    
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
    
    func playAudio(url: URL){
        if(audioReceiverType == .audioStream){
            //LGToneManager prepares the player instance by adding tap to it to recognise the tones directly using audio stream buffer
            LGToneManager.shared().prepareAVPlayer(for: url, onPlayerReady: { (avPlayer, error) in
                if let _ = avPlayer{
                    self.player = avPlayer
                    self.player?.play()
                    
                    NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                        if(self.loopAudio){ //play again from start
                            self.player?.seek(to: kCMTimeZero)
                            self.player?.play()
                        }else{ //stop audio
                            self.pauseAudio()
                        }
                    }
                    
                }
            })
        }else{ //audioReceiverType == .mic
            //streaming audio file and starting to listen through the mic in viewWillAppear
            let playerItem:AVPlayerItem = AVPlayerItem(url: url)
            self.player = AVPlayer(playerItem: playerItem)
            self.player?.play()
            
            if(self.loopAudio){
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                    self.player?.seek(to: kCMTimeZero)
                    self.player?.play()
                }
            }
        }
    }
    
    func pauseAudio(){
        playerState = .stopped
        buttonPlayPause.setImage(UIImage(named: "play"), for: UIControlState.normal)
        self.player?.pause()
    }
    
    @IBAction func playPauseButtonTapped(_ sender: UIButton) {
        if playerState == .playing{ //Tapped stop/pause button
            pauseAudio()
        }else{ //Tapped play button
            playerState = .playing
            sender.setImage(UIImage(named: "stop"), for: UIControlState.normal)
            playAudio(url: defaultFeedURL!)
        }
    }
    
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        slideMenuController()?.openLeft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Starts recording and listening for tone
        if(audioReceiverType == AudioReceiverType.mic){
            LGToneManager.shared().start()
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == kMainToneActionSegue {
            let toneActionViewController = segue.destination as! ToneActionViewController
            toneActionViewController.action = sortedActions[0] as! LGAction
        }
    }
}

