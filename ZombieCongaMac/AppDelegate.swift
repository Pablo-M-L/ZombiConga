//
//  AppDelegate.swift
//  ZombieCongaMac
//
//  Created by admin on 13/07/2019.
//  Copyright © 2019 admin. All rights reserved.
//


import Cocoa
import SpriteKit
import GameplayKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet var skView: SKView!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {

        let scene = MainMenuScene(size: CGSize(width: 2048, height: 1536))
        scene.scaleMode = .aspectFill

        self.skView!.presentScene(scene)
        self.skView!.ignoresSiblingOrder = true
        self.skView!.showsFPS = true
        self.skView!.showsNodeCount = true

    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
}
