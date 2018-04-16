//
//  MeasureViewController.swift
//  AR Inspirational Bit
//
//  Created by Emma Klint on 2018-04-04.
//  Copyright © 2018 Emma Klint. All rights reserved.
//
import UIKit
import ARKit
class MeasureViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var distance: UILabel!
    var startingPosition: SCNNode?
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else {return}
        guard let currentFrame = sceneView.session.currentFrame else {return}
        if self.startingPosition != nil {
            self.startingPosition?.removeFromParentNode()
            self.startingPosition = nil
            return
        }
        let camera = currentFrame.camera
        let transform = camera.transform
        var translationMatrix = matrix_identity_float4x4
        translationMatrix.columns.3.z = -0.1
        let modifiedMatrix = simd_mul(transform, translationMatrix)
        let sphere = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        sphere.simdTransform = modifiedMatrix
        self.sceneView.scene.rootNode.addChildNode(sphere)
        self.startingPosition = sphere
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        guard let startingPosition = self.startingPosition else {return}
        guard let pointOfView = self.sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let xDistance = location.x - startingPosition.position.x
        let yDistance = location.y - startingPosition.position.y
        let zDistance = location.z - startingPosition.position.z
        DispatchQueue.main.async {
            print("frererff")
            self.distance.text = String(format: "%.2f", self.distanceTravelled(x: xDistance, y: yDistance, z: zDistance)) + "m"
        }
    }
    
    func distanceTravelled(x: Float, y: Float, z: Float) -> Float {
        
        return (sqrtf(x*x + y*y + z*z))
    }
    
}
