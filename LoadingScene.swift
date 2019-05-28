//
//  LoadingScene.swift
//  Battle Void
//
//  Created by Ever Time Cole on 4/10/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import SpriteKit

class LoadingScene: SKScene {
    var menuIsActive = false
    var mode = "Scale"
    
    var valuesForCircle:[String:[CGFloat]] = [
        "Blue Min":[0,1,0],
        "Red Min":[0,1,0],
        "Green Min":[0,1,0],
        "Blue Max":[0,1,1],
        "Red Max":[0,1,1],
        "Green Max":[0,1,1],
        "Duration": [1,20,1],
        "Circle Size": [5,100,5],
        "Chunk Amount": [1,20,1],
        "Circle Amount": [1,30,1],
    ]
    
    var valuesForScale:[String:[CGFloat]] = [
        "Blue":[0,1,0.5],
        "Red":[0,1,0.5],
        "Green":[0,1,0.5],
        "Square Amount": [1,100,50],
        "X Dist":[-1,1,0],
        "Y Dist":[-1,1,0],
        "Object Count":[1,5,2],
        "Point Count":[2,8,4]
    ]
    
    var valuesForMatrix:[String:[CGFloat]] = [
        "Blue":[0,1,0.5],
        "Red":[0,1,0.5],
        "Green":[0,1,0.5]
    ]

    var valuesForEmitter:[String:[CGFloat]] = [
        "Width":[1,20,1],
        "Height":[1,20,1],
        "Emission Range":[0,7,3],
        "Alpha":[0,1,1],
        "Alpha Range":[0,1,0.5],
        "Alpha Speed":[0,1,0.5],
        "Birth Rate":[10,100,40],
        "Blue":[0,1,0.5],
        "Red":[0,1,0.5],
        "Green":[0,1,0.5],
        "Lifetime":[1,20,6],
        "Speed":[10,200,100],
        "Speed Range":[0,10,5],
        "Y Acceleration":[-50,50,0],
        "X Acceleration":[-50,50,0],
        "Color Speed":[0,1,0],
        "Color Range":[0,1,0],
        "Rotation Speed":[-5,5,0]
    ]

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        activateMenu(array: valuesForScale)
    }
    
    func addMatrix() {
        for n in 1...100 {
            let matrixLine = MatrixLine(rect: CGRect(x: (n-50)*15, y: Int(random(min: -200, max: 0)), width: 10, height: Int(random(min: 150, max: 250))))
            matrixLine.lineWidth = 0
            self.addChild(matrixLine)
            matrixLine.didMove()
        }
    }
    
    func addCircles() {
        for vv in 1...Int(valuesForCircle["Circle Amount"]![2]) {
            let radius = CGFloat(vv)*valuesForCircle["Circle Size"]![2]
            let amnt = Int(valuesForCircle["Chunk Amount"]![2])
            for v in 0...amnt {
                let ang = (CGFloat.pi * 2)/CGFloat(amnt)
                let shape = SKShapeNode(path: pathOfCircleChunkGivenAngle(ang: ang, radius: radius))
                shape.zRotation = ang*CGFloat(v)-ang/2
                shape.lineWidth = 2//random(min: 2, max: 5)
                shape.strokeColor = UIColor(red: random(min: valuesForCircle["Red Min"]![2], max: valuesForCircle["Red Max"]![2]), green: random(min: valuesForCircle["Green Min"]![2], max: valuesForCircle["Green Max"]![2]), blue: random(min: valuesForCircle["Blue Min"]![2], max: valuesForCircle["Blue Max"]![2]), alpha: 1)
                shape.fillColor = .clear
                self.addChild(shape)
                let oppositeSide = valuesForCircle["Circle Size"]![2]*valuesForCircle["Circle Amount"]![2]
                shape.run(SKAction.repeatForever(SKAction.sequence(
                    [SKAction.move(to: CGPoint(x: -1*oppositeSide*cos(ang*CGFloat(v)), y: -1*oppositeSide*sin(ang*CGFloat(v))), duration: TimeInterval(valuesForCircle["Duration"]![2])),
                     SKAction.move(to: CGPoint(x: 0, y: 0), duration: TimeInterval(valuesForCircle["Duration"]![2]))]
                    )))
                shape.run(SKAction.repeatForever(SKAction.rotate(byAngle: 8 * .pi, duration: 2*TimeInterval(valuesForCircle["Duration"]![2]))))
            }
        }
    }
    
    func addScale() {
        for square in 1...Int(valuesForScale["Square Amount"]![2]) {
            var parent = self as SKNode
            while parent.children.isEmpty == false {
                parent = parent.children[0]
            }
            for _ in 1...Int(valuesForScale["Object Count"]![2]) {
                let object = SKShapeNode(circleOfRadius: 150/CGFloat(square))
                object.position = CGPoint(x: random(min: -300, max: 300)/CGFloat(square), y: random(min: -300, max: 300)/CGFloat(square))
                object.fillColor = UIColor(red: random(), green: random(), blue: random(), alpha: 1)
                object.alpha = 0.5
                object.lineWidth = 0
                object.zPosition = valuesForScale["Square Amount"]![2]-CGFloat(square)
                self.addChild(object)
                var actionList:[SKAction] = []
                for _ in 1...Int(valuesForScale["Point Count"]![2]) {
                    actionList.append(SKAction.move(to: CGPoint(x: random(min: -300, max: 300)/CGFloat(square), y: random(min: -300, max: 300)/CGFloat(square)), duration: 3))
                }
                object.run(SKAction.repeatForever(SKAction.sequence(actionList)))
            }
        }
    }
    
    func addEmitter() {
        let emitter = SKEmitterNode()
        self.addChild(emitter)
        emitter.particleSize.width = valuesForEmitter["Width"]![2]
        emitter.particleSize.height = valuesForEmitter["Height"]![2]
        emitter.emissionAngleRange = valuesForEmitter["Emission Range"]![2]
        emitter.particleAlpha = valuesForEmitter["Alpha"]![2]
        emitter.particleAlphaRange = valuesForEmitter["Alpha Range"]![2]
        emitter.particleAlphaSpeed = valuesForEmitter["Alpha Speed"]![2]
        emitter.particleBirthRate = valuesForEmitter["Birth Rate"]![2]
        emitter.particleColor = UIColor(red: valuesForEmitter["Red"]![2], green: valuesForEmitter["Green"]![2], blue: valuesForEmitter["Blue"]![2], alpha: 1)
        emitter.particleLifetime = valuesForEmitter["Lifetime"]![2]
        emitter.particleScale = random()
        emitter.particleScaleRange = random()
        emitter.particleScaleSpeed = random()
        emitter.particleSpeed = valuesForEmitter["Speed"]![2]
        emitter.particleSpeedRange = valuesForEmitter["Speed Range"]![2]
        emitter.yAcceleration = valuesForEmitter["Y Acceleration"]![2]
        emitter.xAcceleration = valuesForEmitter["X Acceleration"]![2]
        emitter.particleRotationSpeed = valuesForEmitter["Rotation Speed"]![2]
        emitter.particleRotationRange = random()
        emitter.particleColorRedRange = valuesForEmitter["Color Range"]![2]
        emitter.particleColorBlueRange = valuesForEmitter["Color Range"]![2]
        emitter.particleColorGreenRange = valuesForEmitter["Color Range"]![2]
        emitter.particleColorRedSpeed = valuesForEmitter["Color Speed"]![2]
        emitter.particleColorBlueSpeed = valuesForEmitter["Color Speed"]![2]
        emitter.particleColorGreenSpeed = valuesForEmitter["Color Speed"]![2]
        emitter.numParticlesToEmit = 0
        emitter.advanceSimulationTime(10)
    }
    
    var activeSlider = Int()
    
    func activateMenu(array: [String:[CGFloat]]) {
        for child in self.children {
            child.removeFromParent()
        }
        menuIsActive = true
        var whichOption = 1
        var xy = CGPoint(x: -250, y: 80)
        for val in array {
            let S = Slider(min: Int(val.value[0]), max: Int(val.value[1]), text: val.key, val: val.value[2])
            S.position = CGPoint(x: xy.x, y: xy.y)
            if xy.y < -120 { xy.x += 200; xy.y = 80 } else { xy.y -= 50 }
            whichOption+=1
            S.tag=whichOption
            self.addChild(S)
        }
        let Cbutton = SButton(path: pathOfButton(rect: CGRect(x: self.frame.minX+self.frame.width/4*0, y: 130, width: self.frame.width/4, height: 50)))
        Cbutton.addText(text: "Circles")
        Cbutton.action = SKAction.run { self.mode = "Circles"; self.activateMenu(array: self.valuesForCircle) }
        self.addChild(Cbutton)
        let Ebutton = SButton(path: pathOfButton(rect: CGRect(x: self.frame.minX+self.frame.width/4*1, y: 130, width: self.frame.width/4, height: 50)))
        Ebutton.addText(text: "Emitter")
        Ebutton.action = SKAction.run { self.mode = "Emitter"; self.activateMenu(array: self.valuesForEmitter) }
        self.addChild(Ebutton)
        let Sbutton = SButton(path: pathOfButton(rect: CGRect(x: self.frame.minX+self.frame.width/4*2, y: 130, width: self.frame.width/4, height: 50)))
        Sbutton.addText(text: "Scale")
        Sbutton.action = SKAction.run { self.mode = "Scale"; self.activateMenu(array: self.valuesForScale) }
        self.addChild(Sbutton)
        let Mbutton = SButton(path: pathOfButton(rect: CGRect(x: self.frame.minX+self.frame.width/4*3, y: 130, width: self.frame.width/4, height: 50)))
        Mbutton.addText(text: "Matrix")
        Mbutton.action = SKAction.run { self.mode = "Matrix"; self.activateMenu(array: self.valuesForMatrix) }
        self.addChild(Mbutton)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (touches.first?.location(in: self))!.x < -260{
            if menuIsActive==false {
                if mode == "Circles" {
                    activateMenu(array: valuesForCircle)
                } else if mode == "Emitter" {
                    activateMenu(array: valuesForEmitter)
                } else if mode == "Scale" {
                    activateMenu(array: valuesForScale)
                } else if mode == "Matrix" {
                    activateMenu(array: valuesForMatrix)
                }
            } else {
                menuIsActive = false
                for child in self.children {
                    child.removeFromParent()
                }
                if mode == "Circles" {
                    addCircles()
                } else if mode == "Emitter" {
                    addEmitter()
                } else if mode == "Scale" {
                    addScale()
                } else if mode == "Matrix" {
                    addMatrix()
                }
            }
        }
        for child in self.children {
            if let chip = child as? Slider {
                if chip.contains((touches.first?.location(in: self))!) {
                    activeSlider = chip.tag
                }
                if mode == "Circles" {
                    for val in valuesForCircle {
                        if chip.title.text == val.key {
                            valuesForCircle[val.key]![2] = chip.value
                        }
                    }
                } else if mode == "Emitter" {
                    for val in valuesForEmitter {
                        if chip.title.text == val.key {
                            valuesForEmitter[val.key]![2] = chip.value
                        }
                    }
                } else if mode == "Scale" {
                    for val in valuesForScale {
                        if chip.title.text == val.key {
                            valuesForScale[val.key]![2] = chip.value
                        }
                    }
                } else if mode == "Matrix" {
                    for val in valuesForMatrix {
                        if chip.title.text == val.key {
                            valuesForMatrix[val.key]![2] = chip.value
                        }
                    }
                }
            }
            if let chi = child as? SButton {
                if chi.contains((touches.first?.location(in: self))!) {
                    self.run(SKAction.run {chi.doBeginAction()})
                }
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for child in self.children {
            if let chip = child as? Slider {
                if activeSlider == chip.tag {
                    if (touches.first?.location(in: self))!.x-chip.note.frame.width/2<chip.frame.minX {
                        chip.note.position.x = chip.frame.minX+chip.note.frame.width/2 - chip.frame.minX
                    } else if (touches.first?.location(in: self))!.x+chip.note.frame.width/2>chip.frame.maxX {
                        chip.note.position.x = chip.frame.maxX-chip.note.frame.width/2 - chip.frame.minX
                    } else {
                        chip.note.position.x = (touches.first?.location(in: self))!.x - chip.frame.minX
                    }
                }
            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        saveData()
    }
    
    func saveData() {
        for child in self.children {
            if let chip = child as? Slider {
                if activeSlider == chip.tag {
                    activeSlider = 99
                    let A = chip.position.x + chip.note.frame.width/2
                    let B = chip.position.x + chip.frame.width - chip.note.frame.width/2
                    let C = chip.note.position.x + chip.position.x
                    chip.value = ( (C-A) / (B-A) ) * ( chip.max - chip.min ) + chip.min
                    if chip.value < chip.min { chip.value = chip.min }
                    if chip.value > chip.max { chip.value = chip.max }
                }
            }
        }
    }
    override func update(_ currentTime: TimeInterval) {
        for child in self.children {
            if let chi = child as? MatrixLine {
                chi.update()
            }
        }
    }
    
}
