//
//  GameViewController.swift
//  colrercatcher
//
//  Created by Vaughan Webb on 30/09/19.
//  Copyright © 2019 Vaughan Webb. All rights reserved.
//

import UIKit
import SpriteKit


class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let skview = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            let skscene = MainMenu(size: view.bounds.size)
            UserDefaults.standard.set(0, forKey: "Current Score")

                // Set the scale mode to scale to fit the window
            skscene.scaleMode = .aspectFill
        
                // Present the scene
            skview.presentScene(skscene)
            skview.ignoresSiblingOrder = true
            skview.showsFPS = true
            skview.showsNodeCount = true
            skview.showsPhysics = true
        }
    }


}
