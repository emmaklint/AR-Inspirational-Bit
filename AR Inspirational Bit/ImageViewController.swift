//
//  ImageViewController.swift
//  AR Inspirational Bit
//
//  Created by Emma Klint on 2018-04-04.
//  Copyright © 2018 Emma Klint. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ImageViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false;
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.detectionImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        configuration.planeDetection = [.horizontal, .vertical]
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let anchorNode = SCNNode()
        anchorNode.name = "anchor"
        sceneView.scene.rootNode.addChildNode(anchorNode)
        return anchorNode
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imageAnchor = anchor as? ARImageAnchor else { return }
        if let imageName = imageAnchor.referenceImage.name {
            print(imageName)
            
            DispatchQueue.main.async {
                self.textLabel.text = imageName
                let sphere = SCNNode()
                sphere.geometry = SCNSphere(radius: 0.025)
                sphere.geometry?.firstMaterial?.diffuse.contents = UIColor.blue.withAlphaComponent(0.6)
//                sphere.position = SCNVector3(-imageAnchor.referenceImage.physicalSize.width/2,0,0)
                sphere.position = SCNVector3(0,0,0)
                node.addChildNode(sphere)
            }
//
//            if imageName == "King-of-Tokyo" {
//                DispatchQueue.main.async {
//
//                }
//            }
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let planeGeometry = planeAnchor.geometry
        guard let device = MTLCreateSystemDefaultDevice() else { return }
        let plane = ARSCNPlaneGeometry(device: device)
        plane?.update(from: planeGeometry)
        node.geometry = plane
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.geometry?.firstMaterial?.transparency = 0
        node.geometry?.firstMaterial?.fillMode = SCNFillMode.lines
        
    }
}
