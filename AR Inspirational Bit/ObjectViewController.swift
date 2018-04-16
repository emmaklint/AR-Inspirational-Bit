//
//  ObjectViewController.swift
//  AR Inspirational Bit
//
//  Created by Emma Klint on 2018-04-16.
//  Copyright © 2018 Emma Klint. All rights reserved.
//

import UIKit
import ARKit
class ObjectViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        self.sceneView.autoenablesDefaultLighting = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let earth = SCNNode()
        earth.geometry = SCNSphere(radius: 0.2)
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "Earth day")
        earth.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "Earth specular")
        earth.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "Earth emission")
        earth.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "Earth normal")
        earth.position = SCNVector3(0,0, -1)
        self.sceneView.scene.rootNode.addChildNode(earth)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 20)
        let forever = SCNAction.repeatForever(action)
        earth.runAction(forever)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
//extension Int {
//    
//    var degreesToRadians: Double { return Double(self) * .pi/180}
//}


