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


    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Setup your scene here */
        
        var path = NSBundle.mainBundle().pathForResource("SmokeParticle", ofType: "sks")
        var rainParticle = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        
        rainParticle.position = CGPointMake(self.size.width/2, self.size.height)
        rainParticle.name = "rainParticle"
        rainParticle.targetNode = self.scene
        
        self.addChild(rainParticle)
        
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
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

