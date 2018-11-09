//
//  ViewController.swift
//  ARKitExample
//
//  Created by junwoo on 08/11/2018.
//  Copyright © 2018 samchon. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController {
  
  @IBOutlet var sceneView: ARSCNView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Set the view's delegate
    sceneView.delegate = self
    
    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true
    
//    sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin,
//                              ARSCNDebugOptions.showFeaturePoints]
    
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
    
    // Create a new scene
    //let scene = SCNScene(named: "art.scnassets/iPhoneX/iPhoneX.scn")!
    
    // Set the scene to the view
    //sceneView.scene = scene
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    
    // Run the view's session
    sceneView.session.run(configuration)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    
    // Pause the view's session
    sceneView.session.pause()
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
}


extension ViewController: ARSCNViewDelegate {
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    print("horizontal surface detected")
    let planeAnchor = anchor as! ARPlaneAnchor
    let planeNode = createPlane(planeAnchor: planeAnchor)
    node.addChildNode(planeNode)
    
  }
  
  func createPlane(planeAnchor: ARPlaneAnchor) -> SCNNode {
    let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x),
                         height: CGFloat(planeAnchor.extent.z))
    
    plane.firstMaterial?.diffuse.contents = UIImage(named: "grid")
    plane.firstMaterial?.isDoubleSided = true
    
    let planeNode = SCNNode(geometry: plane)
    planeNode.position = SCNVector3(planeAnchor.center.x,
                                    planeAnchor.center.y,
                                    planeAnchor.center.z)
    planeNode.eulerAngles.x = -.pi/2
    return planeNode
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    print("horizontal surface updated")
    
    node.enumerateChildNodes { (childNode, _) in
      childNode.removeFromParentNode()
    }
    let planeAnchor = anchor as! ARPlaneAnchor
    let planeNode = createPlane(planeAnchor: planeAnchor)
    node.addChildNode(planeNode)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    print("horizontal surface removed")
    node.enumerateChildNodes { (childNode, _) in
      childNode.removeFromParentNode()
    }
  }
}
