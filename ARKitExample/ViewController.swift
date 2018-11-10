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
  var modelsInTheScene: [SCNNode] = []
  
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
    
    //모델 위에서는 focussqure 가 사라지도록
    guard let pointOfView = sceneView.pointOfView else { return }
    let firstVisibleModel = modelsInTheScene.first { (node) -> Bool in
      return sceneView.isNode(node, insideFrustumOf: pointOfView)
    }
    let modelsAreVisible = firstVisibleModel != nil
    if modelsAreVisible != focusSquareLocal.isHidden {
      focusSquareLocal.setHidden(to: modelsAreVisible)
    }
      
    let hitTest = sceneView.hitTest(screenCenter, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
    if let hitTestResult = hitTest.first {
      //print("focussquare hit the plane")
      let canAddNewModel: Bool = hitTestResult.anchor is ARPlaneAnchor
      focusSquareLocal.isClosed = canAddNewModel
    } else {
      //print("focussqure does not hit the plane")
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

//add object model
extension ViewController {
  
  fileprivate func getModel(named name: String) -> SCNNode? {
    let scene = SCNScene(named: "art.scnassets/\(name)/\(name).scn")
    guard let model = scene?.rootNode.childNode(withName: "SketchUp", recursively: false) else { return nil }
    model.name = name
    
    var scale: CGFloat
    switch name {
    case "iPhoneX":
      scale = 0.025
    case "MyWatch":
      scale = 0.0000038
    default:
      scale = 1.0
    }
    model.scale = SCNVector3(scale, scale, scale)
    
    return model
  }
  
  @IBAction func addButtonTapped(_ sender: Any) {
    print("button tap")
    guard focusSquare != nil else { return }
    let modelName = "iPhoneX"
    
    guard let model = getModel(named: modelName) else {
      print("unable to load model")
      return
    }
    
    let hitTest = sceneView.hitTest(screenCenter, types: ARHitTestResult.ResultType.existingPlaneUsingExtent)
    guard let worldTransformColumn3 = hitTest.first?.worldTransform.columns.3 else { return }
    model.position = SCNVector3(worldTransformColumn3.x, worldTransformColumn3.y, worldTransformColumn3.z)
    
    sceneView.scene.rootNode.addChildNode(model)
    print("\(modelName) added successfully")
    
    modelsInTheScene.append(model)
    print("currently have \(modelsInTheScene.count)")
  }
}
