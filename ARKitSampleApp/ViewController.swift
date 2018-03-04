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

class ViewController: UIViewController {

    // Views
    @IBOutlet var sceneView: ARSCNView!
    // Private properties
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
        addLightNode()
        addGestureRecognizer()
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
        sceneView.showsStatistics = true
        if let mainScene = SCNScene(named: mainSceneName){
            sceneView.scene = mainScene
        }
    }
    
    private func configureRootNode(){
        let node = sceneView.scene.rootNode.childNode(withName: rootNodeName, recursively: false)
        node?.position = SCNVector3(0, -5, -5)
    }
    
    private func configureChildNodes(){
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == ballNodeName {
                ball = node
                updateBallNode()
            }else if node.name == boxNodeName {
                box = node
                updateBoxNode()
            }
        }
    }
    
    private func addLightNode(){
        sceneView.scene.rootNode.addChildNode(createLightNode())
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
    
    private func addGestureRecognizer(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        sceneView.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer){
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(touchLocation, options: [:])
        if !hitTestResults.isEmpty {
            performActionsOnTappedObjects(hitTestResults)
        }
    }
    
    private func performActionsOnTappedObjects(_ results: [SCNHitTestResult]){
        for result in results {
            if result.node == ball {
                makeBallMoving()
            }
        }
    }
    
    private func makeBallMoving(){
        ball.physicsBody?.applyForce(SCNVector3(0,10,0), asImpulse: true)
    }
    
    private func updateConfiguration(){
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
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
}
