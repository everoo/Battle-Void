//
//  ResetControls.swift
//  Battle Void
//
//  Created by Ever Time Cole on 4/5/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import SpriteKit

class ResetControls: SKScene {
    var texts =
        ["Your\nHealth":"Please choose the quadrant you want to be your health",
         "Enemy\nHealth":"Please choose the quadrant you want to be the enemy's health",
         "Bullet\nCool Down":"Please choose the quadrant you want to be the bullet cooldown",
         "Force Field\nCool Down":"Please choose the quadrant you want to be the forcefield cooldown",
    ]
    let LBL = SKLabelNode(text: "wootT")
    var currentChoice = ["":""].randomElement()
    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        currentChoice = texts.popFirst()
        LBL.text = currentChoice?.value
        LBL.fontName = "Avenir-Light"
        LBL.lineBreakMode = .byWordWrapping
        LBL.numberOfLines = 0
        LBL.fontSize = 30
        LBL.zPosition = 10
        let topButton = SButton(path: pathOfTriY(yScale: self.frame.height/2, xScale: self.frame.width/2))
        topButton.addText(text: "Top")
        topButton.tag = 3
        let leftButton = SButton(path: pathOfTriX(yScale: self.frame.height/2, xScale: self.frame.width/2))
        leftButton.addText(text: "Left")
        leftButton.tag = 1
        let bottomButton = SButton(path: pathOfTriY(yScale: self.frame.height / -2, xScale: self.frame.width/2))
        bottomButton.addText(text: "Bottom")
        bottomButton.tag = 4
        let rightButton = SButton(path: pathOfTriX(yScale: self.frame.height/2, xScale: self.frame.width / -2))
        rightButton.addText(text: "Right")
        rightButton.tag = 2
        self.addChild(topButton)
        self.addChild(leftButton)
        self.addChild(bottomButton)
        self.addChild(rightButton)
        self.addChild(LBL)
        for child in self.children {
            if let chip = child as? SButton {
                chip.action = SKAction.run {
                    chip.addText(text: self.currentChoice!.key)
                    UserDefaults.standard.set(chip.tag, forKey: self.currentChoice!.key)
                    chip.action = SKAction.wait(forDuration: 0)
                    self.currentChoice = self.texts.popFirst()
                    if self.currentChoice==nil{
                        self.chooseSides()
                    }
                    self.LBL.text = self.currentChoice?.value
                }
            }
        }
    }
    
    func chooseSides() {
        for child in self.children {
            if child is SButton {
                child.removeFromParent()
            }
        }
        LBL.text = "Choose the side you want to be your joystick, the other will become the trigger side. You will be redirected to the menu screen when you choose."
        let leftButton = SButton(rect: CGRect(x: self.frame.width / -2, y: self.frame.height / -2, width: self.frame.width/2, height: self.frame.height))
        let rightButton = SButton(rect: CGRect(x: 0, y: self.frame.height / -2, width: self.frame.width/2, height: self.frame.height))
        leftButton.addText(text: "Left")
        rightButton.addText(text: "Right")
        leftButton.action = SKAction.run { self.endScene(side: 1) }
        rightButton.action = SKAction.run { self.endScene(side: -1) }
        self.addChild(leftButton)
        self.addChild(rightButton)
        LBL.zPosition = 15
    }
    
    func endScene(side: Int) {
        UserDefaults.standard.set(side, forKey: "left")
        self.view?.presentScene(menuScene(fileNamed: "SK"))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            for child in self.children {
                if let chi = child as? SButton {
                    if chi.contains(touch.location(in: self)) {
                        chi.doBeginAction()
                    }
                }
            }
        }
    }
    
}
