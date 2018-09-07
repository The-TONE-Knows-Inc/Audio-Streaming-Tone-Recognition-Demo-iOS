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
import MediaPlayer

class ViewController: UIViewController, LGToneManagerDelegate {
    
    var sortedActions:NSArray = NSArray()

    let kMainToneActionSegue = "HomeToneActionSegue"
    let kClientName: String = "TONE_PROTOCOL_CLIENT_NAME"
    let kHostName: String = "TONE_PROTOCOL_HOST_NAME"
    var player: AVPlayer?
    let feedURL1: URL = URL(string: "http://192.168.11.149:8888/tone/AirKast_SubwayRadio_15K_XXXX_ZZZZ_R22_W_PreRoll_44.1k.mp3")!
    let feedURL2: URL = URL(string: "http://192.168.11.149:8888/tone/ZZZZ_XXXX_DDDD___ZZZZ___XXXX___DDDD_44.1k_mixed.mp3")!
    
    @IBOutlet weak var buttonPlayPause: UIButton!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var labelFeedName: UILabel!
    @IBOutlet weak var wrapperView: UIView!
    
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
        
        //Add system volume slider
        let volumeView = MPVolumeView(frame: self.wrapperView.bounds)
        self.wrapperView.addSubview(volumeView)
        
        // Tone Manager initialization
        initToneManager()
        
        //Init player
        self.labelFeedName.text = "Feed 1"
        self.buttonPrevious.isEnabled = false
        self.buttonNext.isEnabled = true
        self.initPlayer(url: feedURL1, shouldPlayAfterInit: false)
        
        //Enable playing audio in background
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
    }
    
    func initToneManager(){
        LGToneManager.shared().delegate = self
        LGToneManager.shared().handleNotifications(inFramework: false)
        LGToneManager.shared().shouldIgnoreSameSequence(inFramework: true)
        let clientName: String = Bundle.main.infoDictionary![kClientName] as! String
        let hostName: String = Bundle.main.infoDictionary![kHostName] as! String
        LGToneManager.shared().configureManagerClientName(clientName, hostName: hostName)
    }
    
    func initPlayer(url: URL, shouldPlayAfterInit: Bool) {
        
        //LGToneManager prepares the player instance by adding tap to it to recognise the tones directly using audio stream buffer
        LGToneManager.shared().prepareAVPlayer(for: url, onPlayerReady: { (avPlayer, error) in
            if let _ = avPlayer{
                self.player = avPlayer
                if(shouldPlayAfterInit){
                    self.playAudio()
                }
                NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: self.player?.currentItem, queue: .main) { _ in
                    self.pauseAudio()
                    self.player?.seek(to: kCMTimeZero)
                }
            }
        })
    }
    
    func playAudio(){
        playerState = .playing
        self.buttonPlayPause.setImage(UIImage(named: "stop"), for: UIControlState.normal)
        self.player?.play()
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
            playAudio()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        self.labelFeedName.text = "Feed 1"
        self.buttonPrevious.isEnabled = false
        self.buttonNext.isEnabled = true
        self.initPlayer(url: feedURL1, shouldPlayAfterInit: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        self.labelFeedName.text = "Feed 2"
        self.buttonNext.isEnabled = false
        self.buttonPrevious.isEnabled = true
        self.initPlayer(url: feedURL2, shouldPlayAfterInit: true)
    }
    
    @IBAction func didPressMenuButton(_ sender: UIBarButtonItem) {
        slideMenuController()?.openLeft()
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

