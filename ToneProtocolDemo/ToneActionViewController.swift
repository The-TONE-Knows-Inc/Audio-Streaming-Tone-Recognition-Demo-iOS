//
//  ToneActionViewController.swift
//  ToneProtocolDemo
//
//  Created by Shalaka Saraf on 07/06/18.
//  Copyright © 2018 Shalaka Saraf. All rights reserved.
//

import UIKit
import ToneFramework

class ToneActionViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var toneActionWebView: UIWebView!
    var action: LGAction = LGAction()
    
    var spinner: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Loads url in webview
        let url = URL(string: action.actionURL)
        let request = URLRequest(url: url! as URL)
        self.toneActionWebView.delegate = self
        self.toneActionWebView.scalesPageToFit = true
        self.toneActionWebView.loadRequest(request)
        spinner = UIViewController.displaySpinner(onView: self.view)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIViewController.removeSpinner(spinner: spinner)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIViewController.removeSpinner(spinner: spinner)
    }
    
    @IBAction func didPressCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
