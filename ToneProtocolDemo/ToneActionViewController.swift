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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var spinnerView: UIView!
    var action: LGAction = LGAction()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toneActionWebView.delegate = self
        activityIndicator.activityIndicatorViewStyle = .gray
        loadUrl(action: action)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.spinnerView.isHidden = false
        self.closeButton.isEnabled = false
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        stopLoader()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        stopLoader()
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
        stopLoadingRequest()
        self.toneActionWebView.loadRequest(request)
    }
    
    func stopLoadingRequest() {
        if self.toneActionWebView.isLoading {
            self.toneActionWebView.stopLoading()
            stopLoader()
        }
    }
    
    func stopLoader(){
        activityIndicator.stopAnimating()
        self.activityIndicator.isHidden = true
        self.spinnerView.isHidden = true
        self.closeButton.isEnabled = true
    }
}
