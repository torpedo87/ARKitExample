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
  var focusSquare: FocusSquare?
  var screenCenter: CGPoint!
  
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
    
    screenCenter = view.center
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
  
  //landscape mode
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    let viewCenter = CGPoint(x: size.width / 2, y: size.height / 2)
    screenCenter = viewCenter
  }
  
  func updateFocusSquare() {
    guard let focusSquareLocal = focusSquare else { return }
    
    let hitTest = sceneView.hitTest(screenCenter, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
    if let hitTestResult = hitTest.first {
      print("focussquare hit the plane")
      let canAddNewModel: Bool = hitTestResult.anchor is ARPlaneAnchor
      focusSquareLocal.isClosed = canAddNewModel
    } else {
      print("focussqure does not hit the plane")
      focusSquareLocal.isClosed = false
    }
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
  
  //물체 감지시
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    print("horizontal surface detected")
//    let planeAnchor = anchor as! ARPlaneAnchor
//    let planeNode = createPlane(planeAnchor: planeAnchor)
//    node.addChildNode(planeNode)
    
    guard focusSquare == nil else { return }
    let focusSquareLocal = FocusSquare()
    sceneView.scene.rootNode.addChildNode(focusSquareLocal)
    focusSquare = focusSquareLocal
  }
  
  //화면에 넣을 가상물체 생성
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
  
  //감지한 물체 업데이트
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    //print("horizontal surface updated")
    
//    node.enumerateChildNodes { (childNode, _) in
//      childNode.removeFromParentNode()
//    }
//    let planeAnchor = anchor as! ARPlaneAnchor
//    let planeNode = createPlane(planeAnchor: planeAnchor)
//    node.addChildNode(planeNode)
  }
  
  //감지한 물체 제거
  func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
    guard anchor is ARPlaneAnchor else { return }
    print("horizontal surface removed")
//    node.enumerateChildNodes { (childNode, _) in
//      childNode.removeFromParentNode()
//    }
  }
  
  
  //frame update
  func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    guard let focusSquareLocal = focusSquare else { return }
    
    //screenCenter를 2D -> 3D 로 만들어서 focusSquare 를 plane 과 같은 레벨에 위치시키기
    let hitTest = sceneView.hitTest(screenCenter, types: ARHitTestResult.ResultType.existingPlane)
    let hitTestResult = hitTest.first
    guard let worldTransform = hitTestResult?.worldTransform else { return }
    let worldTransformColumn3 = worldTransform.columns.3
    focusSquareLocal.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
    
    DispatchQueue.main.async {
      self.updateFocusSquare()
    }
  }
}
