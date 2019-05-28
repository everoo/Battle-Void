//
//  MenuScene.swift
//  Battle Void
//
//  Created by Ever Time Cole on 4/4/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import SpriteKit

class menuScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        for v in 0...3 {
            let BG = SKEmitterNode()
            BG.zRotation = CGFloat(v)*CGFloat.pi/2
            BG.particleColor = .white
            BG.yAcceleration = 50
            BG.particleLifetime = 3
            BG.emissionAngleRange = 7*CGFloat.pi/10
            BG.particleSpeed = 100
            BG.particleBirthRate = 25
            BG.particleSize = CGSize(width: 1, height: 1)
            BG.particleScaleRange = 0.75
            BG.particleScaleSpeed = 1
            self.addChild(BG)
            BG.advanceSimulationTime(5)
        }
        let actionList:[SKAction] = [
            SKAction.run { self.view?.presentScene(ResetControls(fileNamed: "SK")) },
            SKAction.run { self.view?.presentScene(GameScene(fileNamed: "SK")) },
            SKAction.run { self.view?.presentScene(LoadingScene(fileNamed: "SK")) }
        ]
        let textList:[String] = [
            "Reset\nControls",
            "Play\nGame",
            "break"
        ]
        let frameList:[CGRect] = [
            CGRect(x: self.frame.minX, y: self.frame.minY, width: self.frame.width/2, height: self.frame.height/2),
            CGRect(x: self.frame.minX, y: self.frame.midY, width: self.frame.width, height: self.frame.height/2),
            CGRect(x: self.frame.midX, y: self.frame.minY, width: self.frame.width/2, height: self.frame.height/2),
        ]
        let t = actionList.count
        for v in 0...(t-1) {
            let button = SButton(path: pathOfButton(rect: frameList[v]))
            button.addText(text: textList[v])
            button.action = actionList[v]
            button.physicsBody = SKPhysicsBody(polygonFrom: button.path!)
            self.addChild(button)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            for child in self.children {
                if let chi = child as? SButton {
                    if chi.contains(touch.location(in: self)) {
                        self.physicsWorld.gravity = CGVector(dx: 0, dy: -10)
                        self.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),SKAction.run {chi.doBeginAction()}]))
                    }
                }
            }
        }
    }

}
