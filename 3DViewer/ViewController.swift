//
//  ViewController.swift
//  3DViewer
//
//  Created by persen on 2021/4/21.
//

import UIKit
import SceneKit

enum SurfaceType: Int {
    case Basic = 1
    case Normal = 2
    case Height = 3
    case Roughnes = 4
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1: Load .scn file
        let scene = SCNScene(named: "Jimi_2_box.scn")

        // 2: Add camera node
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        // 3: Place camera
        cameraNode.position = SCNVector3(x: 0, y: 3, z: 10)
        // 4: Set camera on scene
        scene?.rootNode.addChildNode(cameraNode)

        // 5: Adding light to scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 0, z: 100)
        scene?.rootNode.addChildNode(lightNode)
        
        // 6: Creating and adding ambien light to scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light?.type = .ambient
        ambientLightNode.light?.color = UIColor.white
        scene?.rootNode.addChildNode(ambientLightNode)

        // If you don't want to fix manually the lights
//        sceneView.autoenablesDefaultLighting = true

        // Allow user to manipulate camera
        sceneView.allowsCameraControl = true

        // Show FPS logs and timming
         sceneView.showsStatistics = true

        // Set background color
        sceneView.backgroundColor = UIColor.white

        // Allow user translate image
        sceneView.cameraControlConfiguration.allowsTranslation = false

        // Set scene settings
        sceneView.scene = scene
    }
    @IBOutlet weak var sceneView: SCNView!

    private let surfaceNames = [SurfaceType.Basic : "Wood_08_3K_Base_Color",
                                SurfaceType.Normal : "Wood_08_3K_Normal",
                                SurfaceType.Height : "Wood_08_3K_Height",
                                SurfaceType.Roughnes : "Wood_08_3K_Roughness",
    ]

    @IBAction func switchSurface(_ sender: UIButton) {
        if let type = SurfaceType(rawValue: sender.tag) {
            changeSurface(by: type)
        }
    }
}

extension ViewController {
    private func changeSurface(by type: SurfaceType) {
        guard let scene = sceneView.scene else {
            return
        }
        guard let cubeNode = scene.rootNode.childNode(withName: "Cube", recursively: true) else {
            return
        }
        if let imageNamed = surfaceNames[type], let materials = cubeNode.geometry?.materials  {
            for material in materials where material.name == "Wood_2" {
                material.diffuse.contents = UIImage(named: imageNamed)
            }
        }
    }
}

