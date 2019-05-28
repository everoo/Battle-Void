//
//  GameViewController.swift
//  Battle Void
//
//  Created by Ever Time Cole on 2/28/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

let devWidth = UIScreen.main.bounds.width
let devHeight = UIScreen.main.bounds.height
public let maxAspectRatio: CGFloat = devHeight / devWidth

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if let view = self.view as! SKView? {
            view.presentScene(menuScene(fileNamed: "SK"))
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
