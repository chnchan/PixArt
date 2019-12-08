//
//  State.swift
//  Pixart
//
//  Created by Hin Chan on 11/26/19.
//  Copyright © 2019 UC Davis. All rights reserved.
//

import Foundation
import UIKit

// MARK: Pod SideMenu has a bug where push will sometimes cause black screen flicker. Using present for now, but as a result, pan gesture side menu will be disabled.

struct Application {
    static let canvas_sizes: [Int] = [8, 16, 24, 32]
    static let transition_speed: TimeInterval = 0.2
    
    static var safeArea_top: Int = 0
    static var device_width: Int = 0
    static var sidemenu_initialized: Bool = false
    static var current_VC: UIViewController?
    static var canvas_backgroundColor: UIColor = UIColor.white
}
