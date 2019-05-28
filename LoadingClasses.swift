//
//  LoadingClasses.swift
//  Battle Void
//
//  Created by Ever Time Cole on 5/3/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import SpriteKit

class Slider: SKShapeNode {
    var value = CGFloat()
    var min = CGFloat()
    var max = CGFloat()
    var tag = Int()
    let note = SKShapeNode(path: pathOfForceField(scaler: 10))
    let title = SKLabelNode()
    let minLBL = SKLabelNode(text: "0")
    let maxLBL = SKLabelNode(text: "1")
    init(min: Int, max: Int, text: String, val: CGFloat) {
        super.init()
        value = val
        self.max = CGFloat(max)
        self.min = CGFloat(min)
        self.path = pathOfSlider(scaler: 20)
        self.fillColor = .black
        self.zPosition = 5
        note.zPosition = 16
        note.fillColor = .blue
        note.lineWidth = 0
        self.lineWidth = 2
        self.strokeColor = .darkGray
        note.position = CGPoint(x: self.position.x+note.frame.width/2+((self.frame.width-note.frame.width)*((value-self.min)/(self.max-self.min))), y: self.position.y+10)
        title.position = CGPoint(x: self.frame.midX, y: self.position.y+25)
        minLBL.fontName = "Avenir-Light"
        minLBL.fontSize = 25
        maxLBL.fontName = "Avenir-Light"
        maxLBL.fontSize = 25
        title.fontName = "Avenir-Light"
        title.fontSize = 25
        minLBL.position = CGPoint(x: self.position.x-10, y: self.position.y)
        maxLBL.position = CGPoint(x: self.position.x+self.frame.width+5, y: self.position.y)
        title.text = text
        minLBL.text = "\(min)"
        maxLBL.text = "\(max)"
        self.addChild(minLBL)
        self.addChild(maxLBL)
        self.addChild(title)
        self.addChild(note)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MatrixLine : SKShapeNode {
    let heigh = Int(random(min: 5, max: 15))
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let updateTime = random(min: 0.1, max: 0.5)
    override init() {
        super.init()
    }
    
    func didMove() {
        for letter in 0...heigh {
            let lett = SKLabelNode(text: String( letters.randomElement()! ))
            let wantedHeight = self.frame.height/CGFloat(heigh)
            lett.position = CGPoint(x: self.frame.minX, y: self.frame.minY+(wantedHeight*CGFloat(letter)))
            lett.fontColor = .init(red: 0, green: 0.5, blue: 0, alpha: random()/4+0.75)
            lett.fontSize = 22
            self.addChild(lett)
        }
    }
    
    func update() {
        for child in self.children {
            if let chi = child as? SKLabelNode {
                chi.text = String( letters.randomElement()! )
                chi.alpha += random(min: -0.1, max: 0.1)
                //chi.fontSize += random(min: -1, max: 1)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
