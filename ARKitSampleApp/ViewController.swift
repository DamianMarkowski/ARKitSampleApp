//
//  ViewController.swift
//  ARKitSampleApp
//
//  Created by Damian Markowski on 04.03.2018.
//  Copyright © 2018 Damian Markowski. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    // Views
    @IBOutlet var sceneView: ARSCNView!
    // Private properties
    private var scene: SCNScene!
    private var ball = SCNNode()
    private var box = SCNNode()
    // Constants
    private let mainSceneName = "art.scnassets/MainScene.scn"
    private let rootNodeName = "Node"
    private let ballNodeName = "Ball"
    private let boxNodeName = "Box"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSceneView()
        configureRootNode()
        configureChildNodes()
        scene.rootNode.addChildNode(createLightNode())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateConfiguration()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    // MARK: Private methods
    
    private func configureSceneView(){
        sceneView.delegate = self
        sceneView.showsStatistics = true
        if let mainScene = SCNScene(named: mainSceneName){
            scene = mainScene
            sceneView.scene = scene
        }
    }
    
    private func configureRootNode(){
        let node = scene.rootNode.childNode(withName: rootNodeName, recursively: false)
        node?.position = SCNVector3(0, -5, -5)
    }
    
    private func configureChildNodes(){
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == ballNodeName {
                ball = node
                updateBallNode()
            }else if node.name == boxNodeName {
                box = node
                updateBoxNode()
            }
        }
    }
    
    private func updateConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    private func createLightNode() -> SCNNode {
        let lightNode = SCNNode()
        lightNode.light = createLight()
        lightNode.position = SCNVector3(x: 1.5, y: 1.5, z: 1.5)
        return lightNode
    }
    
    private func createLight() -> SCNLight {
        let light = SCNLight()
        light.type = SCNLight.LightType.omni
        return light
    }
    
    private func updateBallNode(){
        ball.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: ball, options: nil))
        ball.physicsBody?.isAffectedByGravity = true
        ball.physicsBody?.restitution = 1
    }
    
    private func updateBoxNode(){
        let boxShape: SCNPhysicsShape = SCNPhysicsShape(geometry: box.geometry!, options: nil)
        box.physicsBody = SCNPhysicsBody(type: .static, shape: boxShape)
        box.physicsBody?.restitution = 1
    }
    
    // MARK: - ARSCNViewDelegate

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
