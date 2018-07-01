//
//  GameElements.swift
//  Flappy_Timmy
//
//  Created by Timmy Tseng on 7/1/18.
//  Copyright © 2018 Timmy Tseng. All rights reserved.
//

import Foundation
import SpriteKit

struct CollisionBitMask {
    static let birdCategory:UInt32 = 0x1 << 0
    static let pillarCategory:UInt32 = 0x1 << 1
    static let flowerCategory:UInt32 = 0x1 << 2
    static let groundCategory:UInt32 = 0x1 << 3
}

extension GameScene {
    
    func createBird() -> SKSpriteNode {
        //1- Here you create a sprite node called “bird” and assign it a texture named “bird1”. We give it a size of 50×50, however, you can adjust it to a different dimensions if you want to. Then, we position the bird in the center of the screen.
        let bird = SKSpriteNode(texture: SKTextureAtlas(named:"player").textureNamed("bird1"))
        bird.size = CGSize(width: 50, height: 50)
        bird.position = CGPoint(x:self.frame.midX, y:self.frame.midY)
        
        //2- For the bird to be able to behave like a real world physics body (affected by gravity, collide with objects, etc.), it has to be a SKPhysicsBody object. We have defined it to behave like a ball of radius of half of its width.
        bird.physicsBody = SKPhysicsBody(circleOfRadius: bird.size.width / 2)
        bird.physicsBody?.linearDamping = 1.1
        bird.physicsBody?.restitution = 0
        
        //3- A birdCategory is assigned to the player categoryBitMask property. If two bodies collide, we identify the two bodies by their categoryBitMasks. The collisionBitMask is set to pillarCategory and groundCategory to detect collisions with pillar and ground for this body. The contactTestBitMask is assigned to pillar, ground and flower because you will want to check for contacts with these bodies.
        bird.physicsBody?.categoryBitMask = CollisionBitMask.birdCategory
        bird.physicsBody?.collisionBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.groundCategory
        bird.physicsBody?.contactTestBitMask = CollisionBitMask.pillarCategory | CollisionBitMask.flowerCategory | CollisionBitMask.groundCategory
        
        //4- Here you set the bird to be affected by gravity. The bird will be pushed upward when you touch the screen and then will come down itself.
        bird.physicsBody?.affectedByGravity = false
        bird.physicsBody?.isDynamic = true
        
        return bird
    }
    
    //1- This will create the restart button and add it to the scene. Whenever this function is called, the restart button re-appears on the screen. You also added a scale animation to it. Initially, the scale is set to zero and then an SKAction is executed after adding it to the scene, which scales it to its original size in a duration of 0.3 seconds.
    func createRestartBtn() {
        restartBtn = SKSpriteNode(imageNamed: "restart")
        restartBtn.size = CGSize(width:100, height:100)
        restartBtn.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        restartBtn.zPosition = 6
        restartBtn.setScale(0)
        self.addChild(restartBtn)
        restartBtn.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //2- Here you simply make the pause button and add it to the scene.
    func createPauseBtn() {
        pauseBtn = SKSpriteNode(imageNamed: "pause")
        pauseBtn.size = CGSize(width:40, height:40)
        pauseBtn.position = CGPoint(x: self.frame.width - 30, y: 30)
        pauseBtn.zPosition = 6
        self.addChild(pauseBtn)
    }
    //3- You create a label node to display the score. It is assigned the string representation of the integer score. The code set it nearly to the top of the screen. It then creates an SKShapeNode for the background of the label. It is a rectangle of size 100×100 with the corners rounded to half its size. You add it as a child to the score label node and then set its zPosition to -1 to make it behind the text of the label, otherwise, it will mask it.
    func createScoreLabel() -> SKLabelNode {
        let scoreLbl = SKLabelNode()
        scoreLbl.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2 + self.frame.height / 2.6)
        scoreLbl.text = "\(score)"
        scoreLbl.zPosition = 5
        scoreLbl.fontSize = 50
        scoreLbl.fontName = "HelveticaNeue-Bold"
        
        let scoreBg = SKShapeNode()
        scoreBg.position = CGPoint(x: 0, y: 0)
        scoreBg.path = CGPath(roundedRect: CGRect(x: CGFloat(-50), y: CGFloat(-30), width: CGFloat(100), height: CGFloat(100)), cornerWidth: 50, cornerHeight: 50, transform: nil)
        let scoreBgColor = UIColor(red: CGFloat(0.0 / 255.0), green: CGFloat(0.0 / 255.0), blue: CGFloat(0.0 / 255.0), alpha: CGFloat(0.2))
        scoreBg.strokeColor = UIColor.clear
        scoreBg.fillColor = scoreBgColor
        scoreBg.zPosition = -1
        scoreLbl.addChild(scoreBg)
        return scoreLbl
    }
    //4- This makes the highscore label and place it roughly at the top-right corner of the screen. The highscore is saved in UserDefaults, if the value is not found in the UserDefaults (for example when app is first launched), then the label text will be set to zero.
    func createHighscoreLabel() -> SKLabelNode {
        let highscoreLbl = SKLabelNode()
        highscoreLbl.position = CGPoint(x: self.frame.width - 80, y: self.frame.height - 22)
        if let highestScore = UserDefaults.standard.object(forKey: "highestScore"){
            highscoreLbl.text = "Highest Score: \(highestScore)"
        } else {
            highscoreLbl.text = "Highest Score: 0"
        }
        highscoreLbl.zPosition = 5
        highscoreLbl.fontSize = 15
        highscoreLbl.fontName = "Helvetica-Bold"
        return highscoreLbl
    }
    //5- Here you create the logo by assigning the image ‘logo’ to a SKSpriteNode. It also animates its size when it shows up on the screen.
    func createLogo() {
        logoImg = SKSpriteNode()
        logoImg = SKSpriteNode(imageNamed: "logo")
        logoImg.size = CGSize(width: 272, height: 65)
        logoImg.position = CGPoint(x:self.frame.midX, y:self.frame.midY + 100)
        logoImg.setScale(0.5)
        self.addChild(logoImg)
        logoImg.run(SKAction.scale(to: 1.0, duration: 0.3))
    }
    //6- This will create the ‘tap to play’ label and add it below the bird in our scene.
    func createTaptoplayLabel() -> SKLabelNode {
        let taptoplayLbl = SKLabelNode()
        taptoplayLbl.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 100)
        taptoplayLbl.text = "Tap anywhere to play"
        taptoplayLbl.fontColor = UIColor(red: 63/255, green: 79/255, blue: 145/255, alpha: 1.0)
        taptoplayLbl.zPosition = 5
        taptoplayLbl.fontSize = 20
        taptoplayLbl.fontName = "HelveticaNeue"
        return taptoplayLbl
    }
    
    func createWalls() -> SKNode  {
        //1- Here you instantiate a flower node just like any other node. You set its categoryBitMask to flower and contactBitMask to bird because you need to detect contacts with the bird.
        let flowerNode = SKSpriteNode(imageNamed: "flower")
        flowerNode.size = CGSize(width: 40, height: 40)
        flowerNode.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2)
        flowerNode.physicsBody = SKPhysicsBody(rectangleOf: flowerNode.size)
        flowerNode.physicsBody?.affectedByGravity = false
        flowerNode.physicsBody?.isDynamic = false
        flowerNode.physicsBody?.categoryBitMask = CollisionBitMask.flowerCategory
        flowerNode.physicsBody?.collisionBitMask = 0
        flowerNode.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        flowerNode.color = SKColor.blue
        
        //2- You create an SKNode object named wallPair to add the top and bottom pillars to it as childs. Then you create the top and bottom pillars and set their scale to 0.5. This scales the nodes to half their sizes, setScale is used to increase or decrease the size of the sprite about the scale factor. Since the same images are used for both the top and bottom pillars, you rotate the top pillar node by 180 degrees for the pillar to orient correctly. Pillars are designed to remain stationary so you assign their dynamic property to false.
        wallPair = SKNode()
        wallPair.name = "wallPair"
        
        let topWall = SKSpriteNode(imageNamed: "pillar")
        let btmWall = SKSpriteNode(imageNamed: "pillar")
        
        topWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 + 420)
        btmWall.position = CGPoint(x: self.frame.width + 25, y: self.frame.height / 2 - 420)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        topWall.physicsBody = SKPhysicsBody(rectangleOf: topWall.size)
        topWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        topWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        topWall.physicsBody?.isDynamic = false
        topWall.physicsBody?.affectedByGravity = false
        
        btmWall.physicsBody = SKPhysicsBody(rectangleOf: btmWall.size)
        btmWall.physicsBody?.categoryBitMask = CollisionBitMask.pillarCategory
        btmWall.physicsBody?.collisionBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.contactTestBitMask = CollisionBitMask.birdCategory
        btmWall.physicsBody?.isDynamic = false
        btmWall.physicsBody?.affectedByGravity = false
        
        topWall.zRotation = CGFloat(Double.pi) //He uses CGFloat.pi
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        wallPair.zPosition = 1
        
        //3- This will generate a random number between -200 and 200 using the random() function, and will add that value to the wallPair “y” position. This places the wallPairs at random heights. You then call the moveAndRemove action on wallPair which moves it horizontally and then removes it when it reaches the other side of the screen.
        let randomPosition = random(min: -200, max: 200)
        wallPair.position.y = wallPair.position.y +  randomPosition
        wallPair.addChild(flowerNode)
        
        wallPair.run(moveAndRemove)
        
        return wallPair
    }
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min : CGFloat, max : CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}
