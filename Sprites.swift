//
//  Sprites.swift
//  Battle Void
//
//  Created by Ever Time Cole on 3/2/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import Foundation
import SpriteKit

//BULLET

class Bullet: SKShapeNode {
    var creator = ""
    init(creator: String) {
        super.init()
        self.creator = creator
        self.path = pathOfForceField(scaler: 4)
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        if self.creator == "player" {
            self.strokeColor = .green
        } else {
            self.strokeColor = .red
        }
        self.lineWidth = 5
        self.physicsBody?.friction = 0
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.contactTestBitMask = 1 + 2 + 4
        self.physicsBody?.angularDamping = 0.0
        self.run(SKAction.wait(forDuration: 7), completion: {self.removeFromParent()})
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//PLAYER

class Player: SKShapeNode {
    var health:CGFloat = 1
    var title = ""
    var controller = ""
    var unprotected = true
    var vector = CGVector()
    
    init(type: String) {
        super.init()
        self.title = type
        self.path = pathOfShip(scaler: 3)
        self.strokeColor = .green
        self.fillColor = .black
        self.lineWidth = 3
        self.zPosition = 3
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.angularDamping = 0.0
        self.physicsBody?.allowsRotation = false
        self.physicsBody?.categoryBitMask = 1
        self.physicsBody?.collisionBitMask = 1 + 4
        self.physicsBody?.contactTestBitMask = 1 + 2 + 4
    }
    
    func rotateAutoMove(enemy: SKShapeNode) {
        let distX = (self.position.x+2000) - (enemy.position.x+2000)
        let distY = (self.position.y+2000) - (enemy.position.y+2000)
        let angle = atan2(distY, distX) + CGFloat.pi
        self.zRotation = angle - 1.57079633
        self.physicsBody?.velocity = CGVector(dx: 200*(cos(angle)+vector.dx), dy: 200*(sin(angle)+vector.dy))
    }
    
    func addForceField() {
        self.unprotected = false
        let forceField = ForceField()
        self.addChild(forceField)
        forceField.run(SKAction.wait(forDuration: 5), completion: {
            self.unprotected = true
            forceField.removeFromParent()
        })
        if title == "player" {
            forceFieldTime = 1
        }
    }
    
    func addMissile() {
        let vv = Missile(creator: self.title)
        vv.position = self.position
        self.parent?.addChild(vv)
    }
    
    func fire() {
        let bulletCopy = Bullet(creator: self.title)
        let bvx = self.position.x + (30 * cos(self.zRotation+1.57079633))
        let bvy = self.position.y + (30 * sin(self.zRotation+1.57079633))
        bulletCopy.position = CGPoint(x: bvx, y: bvy)
        self.parent?.addChild(bulletCopy)
        bulletCopy.physicsBody?.velocity = CGVector(dx: (self.physicsBody?.velocity.dx)!+(500*cos(self.zRotation+1.57079633)), dy: (self.physicsBody?.velocity.dy)!+(500*sin(self.zRotation+1.57079633)))
    }
    
    func takeDamage(amount: CGFloat) {
        if unprotected {
            self.health -= amount
            if self.health <= 0 {
                self.health = 0
                //self.removeFromParent()
                if let vv = self.scene as? GameScene {
                    //vv.goToMenu()
                    vv.switchScenes()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//ASTEROID

class Asteroid: SKShapeNode {
    var health:CGFloat = 1
    var healthBar = SKShapeNode()
    init(scaler: Int) {
        super.init()
        self.path = pathOfAsteroid(scaler: scaler)
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.strokeColor = .darkGray
        self.fillColor = .black
        self.lineWidth = 7
        self.zPosition = 3
        self.physicsBody?.isDynamic = false
        self.position = CGPoint(x: random(min: -2000, max: 2000), y: random(min: -2000, max: 2000))
        self.physicsBody?.categoryBitMask = 4
        self.physicsBody?.collisionBitMask = 1
        self.physicsBody?.contactTestBitMask = 1 + 2 + 8 + 32
        healthBar = SKShapeNode(rect: CGRect(x: -50, y: -5, width: 100, height: 10))
        healthBar.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.7)
        healthBar.lineWidth = 0
        self.addChild(healthBar)
    }
    
    func takeDamage(amount: CGFloat) {
        self.health -= amount
        if self.health <= 0 {
            self.blowUp()
        }
    }

    
    func blowUp() {
        let emitter = SKEmitterNode()
        emitter.position = self.position
        self.parent?.addChild(emitter)
        self.removeFromParent()
        emitter.particleAlpha = 0.9
        emitter.particleAlphaSpeed = -0.9
        emitter.particleSpeed = 300
        emitter.particleColorBlueRange = 0.05
        emitter.particleColorRedRange = 0.05
        emitter.particleColorGreenRange = 0.05
        emitter.particleColor = .darkGray
        emitter.particleScaleRange = 1
        emitter.particleSize = CGSize(width: 30, height: 30)
        emitter.emissionAngleRange = 10
        emitter.particleBirthRate = 60
        emitter.particleLifetime = 0.5
        emitter.numParticlesToEmit = 30
        emitter.run(SKAction.wait(forDuration: 1), completion: {emitter.removeFromParent()})
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//CONTROLS

class controls: SKShapeNode {
    var tall = Bool()
    override init() {
        super.init()
        self.zPosition = 5
    }
    
    func shrink(to: CGFloat) {
        if tall==true {
            self.yScale = to
        } else {
            self.xScale = to
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//UPGRADE

class Upgrade: SKShapeNode {
    var target = SKNode()
    var type = ""
    init(type: String) {
        super.init()
        self.type = type
        self.position = CGPoint(x: random(min: -2000, max: 2000), y: random(min: -2000, max: 2000))
        if type == "forceField" { self.path = pathOfForceFieldUpgrade(scaler: 3) }
        else if type == "missile" { self.path = pathOfMissileUpgrade(scaler: 3) }
        else if type == "medPack"  { self.path = pathOfMedPack(scaler: 3) }
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = 8
        self.physicsBody?.contactTestBitMask = 1
        self.physicsBody?.collisionBitMask = 0
        self.lineWidth = 3
        self.fillColor = UIColor.black
        self.run(SKAction.wait(forDuration: 10), completion: {self.removeFromParent()})
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ForceField: SKShapeNode {
    override init() {
        super.init()
        self.path = pathOfForceField(scaler: 50)
        self.strokeColor = UIColor.blue
        self.lineWidth = 3
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MISSILE

class Missile: SKShapeNode {
    var creator = String()
    init(creator: String) {
        super.init()
        self.creator = creator
        self.path = pathOfMissile(scaler: 3)
        if creator == "player" {
            self.strokeColor = UIColor.green
        } else {
            self.strokeColor = UIColor.red
        }
        self.lineWidth = 3
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.categoryBitMask = 16
        self.physicsBody?.collisionBitMask = 4
        self.physicsBody?.contactTestBitMask = 1 + 2
        self.run(SKAction.wait(forDuration: 20), completion: {self.removeFromParent()})
    }
    
    func point(at: SKShapeNode) {
        let distX = (self.position.x+2000) - (at.position.x+2000)
        let distY = (self.position.y+2000) - (at.position.y+2000)
        if (at.position.x>=self.position.x){
            self.zRotation = atan(distY/distX) - 1.57079633
            self.physicsBody?.velocity = CGVector(dx: 300*cos(atan(distY/distX)), dy: 300*sin(atan(distY/distX)))
        } else {
            self.zRotation = atan(distY/distX) + 1.57079633
            self.physicsBody?.velocity = CGVector(dx: -300*cos(atan(distY/distX)), dy: -300*sin(atan(distY/distX)))
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//SENSOR
class Sensor: SKShapeNode {
    var controller = SKShapeNode()
    var contactPoints = 0
    
    init(controller: SKShapeNode) {
        super.init()
        self.controller = controller
        self.path = pathOfForceField(scaler: 80)
        self.physicsBody = SKPhysicsBody(polygonFrom: self.path!)
        self.physicsBody?.categoryBitMask = 32
        self.physicsBody?.contactTestBitMask = 4
        self.physicsBody?.collisionBitMask = 0
        self.lineWidth = 0
    }
    
    func rotateParent(point: CGPoint) {
        contactPoints += 1
        let distX = point.x - controller.position.x
        let distY = point.y - controller.position.y
        let angle = atan2(distY, distX)
        let vectorr = CGVector(dx: -1*cos(angle), dy: -1*sin(angle))
        if let vv = self.controller as? Player {
            vv.vector = vectorr
        }
    }
    
    func unrotateParent() {
        contactPoints -= 1
        if contactPoints == 0 {
            if let vv = self.controller as? Player {
                vv.vector = CGVector(dx: 0, dy: 0)
            }
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: SKButton
class SButton: SKShapeNode {
    var tex = SKLabelNode()
    var curText = String()
    var action = SKAction()
    var tag = Int()
    override init() {
        super.init()
        self.fillColor = .black
        self.strokeColor = .darkGray
        self.lineWidth = 5
        self.zPosition = 10
        tex.fontName = "Avenir-Light"
        tex.fontSize = 30
        tex.zRotation = random(min: -0.3, max: 0.3)
        tex.lineBreakMode = NSLineBreakMode.byWordWrapping
        tex.numberOfLines = 0
        tex.preferredMaxLayoutWidth = self.frame.width*0.25
        tex.verticalAlignmentMode = .center
        tex.horizontalAlignmentMode = .center
        self.addChild(tex)
    }
    func addText(text: String) {
        tex.text = text
        curText = text
        tex.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func doBeginAction() {
        self.run(action)
    }
}

