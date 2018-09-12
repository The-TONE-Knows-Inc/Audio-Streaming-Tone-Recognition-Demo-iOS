//
//  NavigationProviderProtocol.swift
//  ToneProtocolDemo
//
//  Created by Nikhil Gaonkar on 11/09/18.
//  Copyright © 2018 Tone Protocol. All rights reserved.
//

import Foundation
import UIKit
enum MenuItem {
    case home
    case inbox
}

protocol NavigationProviderProtocol {
    func viewControllerForMenuItem(menuItem : MenuItem)-> UIViewController?;
}
