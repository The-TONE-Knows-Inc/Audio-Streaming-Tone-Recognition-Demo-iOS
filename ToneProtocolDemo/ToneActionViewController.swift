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
    
    var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUrl(action: action)
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        if let _ = spinner {
            UIViewController.removeSpinner(spinner: spinner!)
            spinner = nil
        }
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if let _ = spinner {
            UIViewController.removeSpinner(spinner: spinner!)
            spinner = nil
        }
    }
    
    @IBAction func didPressCloseButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadUrl(action : LGAction) {
        // Loads url in webview
        let url = URL(string: action.actionURL)
        let request = URLRequest(url: url! as URL)
        self.toneActionWebView.delegate = self
        self.toneActionWebView.scalesPageToFit = true
        self.toneActionWebView.loadRequest(request)
        if action.actionType != LGActionType.actionTypeEmail {
            if spinner == nil {
                spinner = UIViewController.displaySpinner(onView: self.view)
            }
        }
    }
}
