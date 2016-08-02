//
//  ViewController.swift
//  Revolver Duel
//
//  Created by Albin Martinsson on 2016-08-02.
//  Copyright © 2016 Dobus. All rights reserved.
//

import UIKit
import CoreMotion
import MultipeerConnectivity
import SpriteKit

let motionKit = MotionKit()

class ViewController: UIViewController {

      let particleEmitter = CAEmitterLayer()
    @IBOutlet weak var smokeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         createParticles()
        
        motionKit.getAccelerometerValues(0.1) { (x, y, z) -> () in
            if(x > 0.85) {
                print("Skjut")
                
            }
            else if 0.55...0.85 ~= x {
                print("Drar vapnet")
            }
            else if 0.10...0.55 ~= x {
                print("Är redo")
            }
            else {
                print("Vapnet hölstrat")
                //self.particleEmitter.removeFromSuperlayer()
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createParticles() {
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let white = makeEmitterCellWithColor(UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.3))
        particleEmitter.emitterCells = [white]
        smokeView.layer.addSublayer(particleEmitter)
        
    }
    
    func makeEmitterCellWithColor(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 20.0
        cell.lifetimeRange = 0
        cell.color = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.5).CGColor
        cell.velocity = 30
        cell.velocityRange = 25
        cell.alphaSpeed =  -1.0/cell.lifetime
        cell.emissionLongitude = CGFloat(M_PI)
        cell.emissionRange = CGFloat(M_PI_4)
        cell.scale = 0.25
        cell.scaleRange = 0.25
        cell.scaleSpeed = -0.05
        cell.contents = UIImage(named: "spark")?.CGImage
        
        return cell
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

