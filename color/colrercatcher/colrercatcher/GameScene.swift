//
//  GameScene.swift
//  colrercatcher
//
//  Created by Vaughan Webb on 30/09/19.
//  Copyright © 2019 Vaughan Webb. All rights reserved.
//

import SpriteKit


class GameScene: SKScene
{
    
    var shapemenu = SKShapeNode()
    var shapewheel = SKSpriteNode()
    var score = 0
    var label = SKLabelNode()
    var shapeball = SKShapeNode()
    var isdead = false
    var currentSelection = 0
    var rand = 0
    var check = false
    var once = true
    
    override func didMove(to view: SKView)
    {
        
                self.run(SKAction.repeatForever(SKAction.sequence([SKAction.colorize(with: UIColor(red: 0.0,green: 0.0, blue: 1.0, alpha: 1.0), colorBlendFactor: CGFloat(1), duration: 3), (SKAction.colorize(with: UIColor(red: 0.5,green: 0.0, blue: 0.5, alpha: 1.0), colorBlendFactor: CGFloat(1), duration: 3))])))
        createshapemenu()
        createshapewheel()
        createScoreLabel()
        createshapeball()
    }
    func createshapeball()
    {
        shapeball = SKShapeNode(circleOfRadius: 20)
        shapeball.fillColor = UIColor.white
        shapeball.position = CGPoint(x: self.frame.width/2, y: self.frame.height + 10)
        self.addChild(shapeball)
    }
    
    func createshapemenu()
    {
        shapemenu = SKShapeNode(rectOf: CGSize(width: 100, height: 100))
        shapemenu.fillColor = SKColor.white
        shapemenu.fillTexture = SKTexture(imageNamed: "doge")
        shapemenu.position = CGPoint(x: self.frame.width - 100, y: self.frame.height - 100)
        self.addChild(shapemenu)
        
    }
    func createshapewheel()
    {
        shapewheel = SKSpriteNode(texture: SKTexture(imageNamed: "wheel"), size: CGSize(width: 200, height: 200))
        shapewheel.position = CGPoint(x: self.frame.width/2, y: self.frame.minY + 150)
        self.addChild(shapewheel)
        
    }
    
    func createScoreLabel()
    {
        label = SKLabelNode()
        label.fontSize = 32.0
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.frame.minX + 100, y: self.frame.height - 100)
        self.addChild(label)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        if (shapeball.hasActions() == false && isdead == false)
        {
            check = false
            shapeball.alpha = 1
            balljazz()
        }
        
        if (shapeball.position.y <= self.frame.minY + 170 && check == false)
        {
            
            check = true
            if (currentSelection == rand)
            {
                score += 1
                label.text = String(score)
                
            }
            else
            {
                isdead = true
            }

        }
        
        if (isdead == true && once == true)
        {
            once = false
            label = SKLabelNode()
            label.text = "game over"
            label.fontSize = 32.0
            label.fontColor = UIColor.white
            label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
            self.addChild(label)
            label = SKLabelNode()
            label.text = "press to continue"
            label.fontSize = 32.0
            label.fontColor = UIColor.white
            label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2 - 50)
            self.addChild(label)
            
        }
    }
    
    
    func balljazz()
    {
        shapeball.position = CGPoint(x: self.frame.width/2, y: self.frame.height + 10)
        rand = Int.random(in: 0 ... 3)
        if (rand == 0)
        {
            shapeball.fillColor = UIColor.blue
        }
        else if (rand == 1)
        {
            shapeball.fillColor = UIColor.green
        }
        else if (rand == 2)
        {
            shapeball.fillColor = UIColor.yellow
        }
        else if (rand == 3)
        {
            shapeball.fillColor = UIColor.red
        }
        
        if (score > 5)
        {
            shapeball.run(SKAction.sequence([SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.minY + 150), duration: 1.5) , SKAction.fadeOut(withDuration: 0.5)]))
        }
        else
        {
            shapeball.run(SKAction.sequence([SKAction.move(to: CGPoint(x: self.frame.midX, y: self.frame.minY + 150), duration: 3) , SKAction.fadeOut(withDuration: 0.5)]))

        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

 
        let location = touches.first?.location(in: self)
        if shapemenu.contains(location!)
        {
            updatescore()
            let newScene = MainMenu(size: (self.view?.bounds.size)!)
            let transistion = SKTransition.reveal(with: .up, duration: 2)
            self.view?.presentScene(newScene, transition:  transistion)
            transistion.pausesIncomingScene = false
            transistion.pausesOutgoingScene = true
            
        }
        else if location!.x < self.frame.width/2
        {
            currentSelection -= 1
            if (currentSelection <= -1)
            {
                currentSelection = 3
            }
            
            shapewheel.run(SKAction.rotate(byAngle: CGFloat((3.141592656358979 * 90) / 180), duration: 0.3))
            if (isdead == true)
            {
                updatescore()
                let newScene = MainMenu(size: (self.view?.bounds.size)!)
                let transistion = SKTransition.reveal(with: .up, duration: 2)
                self.view?.presentScene(newScene, transition:  transistion)
                transistion.pausesIncomingScene = false
                transistion.pausesOutgoingScene = true
            }
        }
        else
        {
            currentSelection += 1
            if (currentSelection >= 4)
            {
                currentSelection = 0
            }
            
            shapewheel.run(SKAction.rotate(byAngle: CGFloat (-(3.141592656358979 * 90) / 180), duration: 0.3))
            if (isdead == true)
            {
                updatescore()
                let newScene = MainMenu(size: (self.view?.bounds.size)!)
                let transistion = SKTransition.reveal(with: .up, duration: 2)
                self.view?.presentScene(newScene, transition:  transistion)
                transistion.pausesIncomingScene = false
                transistion.pausesOutgoingScene = true
            }
            
        }
    }
    
    func updatescore()
    {
        UserDefaults.standard.set(score, forKey: "Current Score")
        if (score > UserDefaults.standard.integer(forKey: "High Score"))
        {
            UserDefaults.standard.set(score, forKey: "High Score")
            
        }
    }
    
}






class MainMenu: SKScene
{
    var label = SKLabelNode()
    var logo = SKSpriteNode()
    
    

    
    override func didMove(to view: SKView)
    {
        createlabel(70, 1)
        createlabel(-70, 2)

        
        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.colorize(with: UIColor(red: 0.0,green: 0.0, blue: 1.0, alpha: 1.0), colorBlendFactor: CGFloat(1), duration: 3), (SKAction.colorize(with: UIColor(red: 0.5,green: 0.0, blue: 0.5, alpha: 1.0), colorBlendFactor: CGFloat(1), duration: 3))])))

        
        logo = SKSpriteNode(texture: SKTexture(imageNamed: "wheel"), size: CGSize(width: 50, height: 50))
        logo.position = CGPoint(x: self.frame.width/2, y: self.frame.maxY - 100)
        addChild(logo)
        
        logo.run(SKAction .repeatForever(SKAction .rotate(byAngle: (3.141592653589793238462 * 90) / 180, duration: 0.5)))
        
        createlabel(300, 3)
        createlabel(-300 , 4)
        label.setScale(CGFloat(1.5))
        label.run(SKAction.repeatForever(SKAction.sequence( ([SKAction.fadeAlpha(to: 0.25, duration: 1) , SKAction.fadeAlpha(to: 1, duration: 1)]))))
      
    }
    
    func createlabel(_ pos: CGFloat, _ type: Int)
    {
        label = SKLabelNode()
        
        if (type == 1)
        {
            label.text = "High Score: " + String(UserDefaults.standard.integer(forKey: "High Score"))
        }
        else if (type == 2)
        {
            
            label.text = "Current score: " + String(UserDefaults.standard.integer(forKey: "Current Score"))
        }
        else if (type == 3)
        {
            label.text = "colrercatcher"
        }
        else if (type == 4)
        {
            
            label.text = "press to play"
        }
        
        label.fontSize = 32.0
        label.fontColor = UIColor.white
        label.position = CGPoint(x: self.frame.midX, y: self.frame.midY + pos)
        self.addChild(label)
        
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {

            let newScene = GameScene(size: (self.view?.bounds.size)!)
            let transition = SKTransition.reveal(with: .down, duration: 2)
            self.view?.presentScene(newScene, transition: transition)

            transition.pausesOutgoingScene = false
            transition.pausesIncomingScene = false

    }
    

}
