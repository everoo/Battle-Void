//
//  GameScene.swift
//  Battle Void
//
//  Created by Ever Time Cole on 2/28/19.
//  Copyright © 2019 Ever Time Cole. All rights reserved.
//

import SpriteKit
import GameplayKit

var forceFieldTime:Double = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var left = UserDefaults.standard.integer(forKey: "left")
    var uicontrol = UIViewController()

    func goToMenu() {
        uicontrol.present(GameViewController(), animated: true, completion: {})
        //uicontrol.endGame()
        self.removeFromParent()
    }
    
    var lastUpdateTime : TimeInterval = 0
    var camPosDelta = CGPoint(x: 0, y: 0)
    var prevPos = CGPoint(x: 0, y: 0)
    var joyActive = false
    let player = Player(type: "player")
    let enemy = Player(type: "enemy")
    let cam = SKCameraNode()
    let startCircle = controls(path: pathOfForceField(scaler: devWidth/11))
    let currentCircle = controls(path: pathOfForceField(scaler: devWidth/11))
    var forceFieldBar = controls(rect: findFrame(tag: UserDefaults.standard.integer(forKey: "Force Field\nCool Down")))
    var reload = controls(rect: findFrame(tag: UserDefaults.standard.integer(forKey: "Bullet\nCool Down")))
    var playerHealthBar = controls(rect: findFrame(tag: UserDefaults.standard.integer(forKey: "Your\nHealth")))
    var enemyHealthBar = controls(rect: findFrame(tag: UserDefaults.standard.integer(forKey: "Enemy\nHealth")))
    var angle = CGFloat()
    var reloadTime:Double = 0
    
    var totalTouches = 0

    override func didMove(to view: SKView) {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.size = CGSize(width: 4000, height: 4000)
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.camera = cam
        cam.xScale = 3/10
        cam.yScale = 3/10*maxAspectRatio
        reload.fillColor = UIColor(red: 1, green: 1, blue: 0, alpha: 0.5)
        reload.lineWidth = 0
        self.addChild(reload)
        forceFieldBar.fillColor = UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        forceFieldBar.lineWidth = 0
        self.addChild(forceFieldBar)
        playerHealthBar.fillColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        playerHealthBar.lineWidth = 0
        self.addChild(playerHealthBar)
        enemyHealthBar.fillColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        enemyHealthBar.lineWidth = 0
        self.addChild(enemyHealthBar)
        for child in self.children {
            if let gr = child as? controls {
                if gr.frame.width > 50 {
                    gr.tall = false
                } else {
                    gr.tall = true
                }
            }
        }
        player.position = CGPoint(x: -1000, y: -1000)
        self.addChild(player)
        enemy.strokeColor = .red
        enemy.position = CGPoint(x: 1000, y: 1000)
        self.addChild(enemy)
        currentCircle.fillColor = UIColor(red: 0, green: 1, blue: 1, alpha: 0.3)
        currentCircle.lineWidth = 0
        startCircle.strokeColor = .darkGray
        for _ in 1...400 {
            let rand = randomInt(maxa: 5)
            let star = SKShapeNode(rect: CGRect(x: Int(random(min: -2000, max: 2000)), y: Int(random(min: -2000, max: 2000)), width: rand, height: rand))
            star.fillColor = UIColor.white
            star.zPosition=0
            self.addChild(star)
        }
        for v in 12...21 {
            let ast = Asteroid(scaler: 100*Int(v/6))
            if CGRect(x: ast.frame.minX-20, y: ast.frame.minY-20, width: ast.frame.width+40, height: ast.frame.height+40).contains(player.frame) == false { self.addChild(ast) }
        }
        for child in self.children {
            if let chi = child as? Player {
                if chi.title.contains("enemy") {
                    self.addChild(Sensor(controller: chi))
                }
            }
        }
    }
    
    func switchScenes() {
        self.view?.presentScene(menuScene(fileNamed: "SK"))
    }
    
//PHYSICS
//player = 1 bullet = 2 asteroid = 4 upgrade = 8 missile = 16 sensor = 32
    func didBegin(_ contact: SKPhysicsContact) {
        let conA = contact.bodyA.categoryBitMask
        let conB = contact.bodyB.categoryBitMask
        
        //ASTEROID + BULLET
        if (conA==4 && conB==2) || (conA==2 && conB==4) {
            (contact.bodyB.node as? Bullet)?.removeFromParent()
            (contact.bodyA.node as? Asteroid)?.takeDamage(amount: 0.02)
            (contact.bodyA.node as? Bullet)?.removeFromParent()
            (contact.bodyB.node as? Asteroid)?.takeDamage(amount: 0.02)
        }
        
        //BULLET + MISSILE
        if (conA==16 && conB==2) || (conA==2 && conB==16) {
            if let conAA = contact.bodyA.node as? Missile, let conBB = contact.bodyB.node as? Bullet{
                if conAA.creator != conBB.creator{
                    conBB.removeFromParent()
                    conAA.removeFromParent()
                }
            }
            if let conAA = contact.bodyA.node as? Bullet, let conBB = contact.bodyB.node as? Missile{
                if conBB.creator != conAA.creator{
                    conAA.removeFromParent()
                    conBB.removeFromParent()
                }
            }
        }
        
        //ASTEROID + SENSOR
        if (conA==32 && conB==4) || (conA==4 && conB==32) {
            if let conAA = contact.bodyA.node as? Sensor{
                conAA.rotateParent(point: contact.contactPoint)
            }
            if let conAA = contact.bodyB.node as? Sensor{
                conAA.rotateParent(point: contact.contactPoint)
            }
        }


        //MISSILE + PLAYER
        if (conA==16 && conB==1) || (conA==1 && conB==16) {
            if let conAA = contact.bodyA.node as? Missile, let conBB = contact.bodyB.node as? Player{
                if conAA.creator != conBB.title{
                    conBB.takeDamage(amount: 0.05)
                    conAA.removeFromParent()
                }
            }
            if let conAA = contact.bodyA.node as? Player, let conBB = contact.bodyB.node as? Missile{
                if conBB.creator != conAA.title{
                    conAA.takeDamage(amount: 0.05)
                    conBB.removeFromParent()
                }
            }
        }

        //PLAYER + UPGRADE
        if (conA==1 && conB==8) || (conA==1 && conB==8) {
            if let bodyB = contact.bodyB.node as? Upgrade {
                if bodyB.type == "medPack" {
                    (contact.bodyA.node as? Player)?.health += 0.05
                }
                if bodyB.type == "forceField" {
                    (contact.bodyA.node as? Player)?.addForceField()
                }
                if bodyB.type == "missile" {
                    (contact.bodyA.node as? Player)?.addMissile()
                }
                bodyB.removeFromParent()
            }
            if let bodyA = contact.bodyA.node as? Upgrade {
                if bodyA.type == "medPack" {
                    (contact.bodyB.node as? Player)?.health += 0.05
                }
                if bodyA.type == "forceField" {
                    (contact.bodyB.node as? Player)?.addForceField()
                }
                if bodyA.type == "missile" {
                    (contact.bodyB.node as? Player)?.addMissile()
                }
                bodyA.removeFromParent()
            }
        }

        //PLAYER + BULLET
        if (conA==1 && conB==2) || (conA==2 && conB==1) {
            if let conAA = contact.bodyA.node as? Player, let conBB = contact.bodyB.node as? Bullet{
                if conAA.title != conBB.creator{
                    conBB.removeFromParent()
                    conAA.takeDamage(amount: 0.02)
                }
            }
            if let conAA = contact.bodyA.node as? Bullet, let conBB = contact.bodyB.node as? Player{
                if conBB.title != conAA.creator{
                    conAA.removeFromParent()
                    conBB.takeDamage(amount: 0.02)
                }
            }
        }
        
        //PLAYER + ASTEROID
        if (conA==1 && conB==4) || (conA==4 && conB==1) {
            (contact.bodyB.node as? Player)?.takeDamage(amount: 0.02)
            (contact.bodyA.node as? Asteroid)?.takeDamage(amount: 0.02)
            (contact.bodyA.node as? Player)?.takeDamage(amount: 0.02)
            (contact.bodyB.node as? Asteroid)?.takeDamage(amount: 0.02)
        }

        
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        let conA = contact.bodyA.categoryBitMask
        let conB = contact.bodyB.categoryBitMask

        if (conA==32 && conB==4) || (conA==4 && conB==32) {
            if let conAA = contact.bodyA.node as? Sensor{
                conAA.unrotateParent()
            }
            if let conAA = contact.bodyB.node as? Sensor{
                conAA.unrotateParent()
            }
        }

    }
        
//TOUCHES
    func touchDownInLeft(pos: CGPoint) {
        if joyActive == false{
            joyActive = true
            startCircle.position = pos
            currentCircle.position = CGPoint(x: pos.x+1, y: pos.y-1)
            self.addChild(startCircle)
            self.addChild(currentCircle)
        }
    }
    
    func touchMovedInLeft(pos: CGPoint) {
        let dist = CGPoint(x: (pos.x+2000) - (startCircle.position.x+2000), y: (pos.y+2000) - (startCircle.position.y+2000))
        angle = atan2(dist.y, dist.x)
        player.zRotation = angle - 1.57079633
        if startCircle.contains(pos) {
            currentCircle.position = pos
        } else {
            currentCircle.position = CGPoint(x: startCircle.position.x + (devWidth/11 * cos(angle)), y: startCircle.position.y + (devWidth/11 * sin(angle)))
        }
        player.physicsBody?.velocity = CGVector(dx: 10*((currentCircle.position.x+2000)-(startCircle.position.x+2000)), dy: 10*((currentCircle.position.y+2000)-(startCircle.position.y+2000)))
    }
    
    func touchEndInLeft() {
        self.startCircle.removeFromParent()
        self.currentCircle.removeFromParent()
        self.joyActive=false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            totalTouches += 1
            if CGFloat(left)*(t.location(in: self).x-cam.position.x) < 0 {
                self.touchDownInLeft(pos: t.location(in: self))
            } else {
                if reloadTime <= 0 {
                    reloadTime = Double(1)
                    player.fire()
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            if CGFloat(left)*(t.location(in: self).x-cam.position.x) < 50{
                touchMovedInLeft(pos: t.location(in: self))
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            totalTouches -= 1
            if (CGFloat(left)*(t.location(in: self).x-cam.position.x) < 50) || (totalTouches == 0) {
                touchEndInLeft()
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
//UPDATE
    var v:Double = 0
    override func update(_ currentTime: TimeInterval) {
    //TIMING
        if (self.lastUpdateTime == 0) { self.lastUpdateTime = currentTime }
        let dt = currentTime - self.lastUpdateTime
        self.lastUpdateTime = currentTime
        if reloadTime <= 0 { reloadTime=0 } else { reloadTime-=dt*2 }
        if forceFieldTime <= 0 { forceFieldTime=0 } else { forceFieldTime-=dt/5 }
        forceFieldBar.shrink(to: CGFloat(forceFieldTime))
        reload.shrink(to: CGFloat(reloadTime))
        playerHealthBar.shrink(to: player.health)
        enemyHealthBar.shrink(to: enemy.health)
        v+=dt
        if v > 2 {
            v = 0
            enemy.fire()
            let typeNum = randomInt(maxa: 3)
            var stri = ""
            if typeNum == 0 { stri = "forceField" }
            if typeNum == 1 { stri = "missile" }
            if typeNum == 2 { stri = "medPack" }
            self.addChild(Upgrade(type: stri))
        }

    //CAMERA
        if player.position.x < 1425 && player.position.x > -1425 {
            cam.position.x = player.position.x
        }
        if player.position.y < 1700 && player.position.y > -1700 {
            cam.position.y = player.position.y
        }
        camPosDelta = CGPoint(x: cam.position.x-prevPos.x, y: cam.position.y-prevPos.y)
        prevPos = cam.position
        for child in self.children {
            if child is controls {
                child.position.x += camPosDelta.x
                child.position.y += camPosDelta.y
            }
            if let chi = child as? Asteroid {
                chi.healthBar.xScale = chi.health
            }
            if let chil = child as? Sensor {
                chil.position = chil.controller.position
            }
            if let chil = child as? Missile {
                if chil.creator == "player" {
                    chil.point(at: enemy)
                } else {
                    chil.point(at: player)
                }
            }
        }
        enemy.rotateAutoMove(enemy: player)
    }
}
