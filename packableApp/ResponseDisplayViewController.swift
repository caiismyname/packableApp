

import UIKit
import SceneKit

class ReponseDisplayViewController: UIViewController {
  // UI
  @IBOutlet weak var geometryLabel: UILabel!
  @IBOutlet weak var sceneView: SCNView!
    
    // Geometry
    var geometryNode: SCNNode = SCNNode()
    
    // Gestures
    var currentAngle: Float = 0.0
    
  // MARK: Lifecycle
  override func viewDidLoad() {
      super.viewDidLoad()
    
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    sceneSetup()
    sceneView.scene!.rootNode.addChildNode(geometryNode)
  }
  
  // MARK: IBActions
  @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
  }
  
  // MARK: Style
  override var preferredStatusBarStyle : UIStatusBarStyle {
    return UIStatusBarStyle.lightContent
  }
  
  // MARK: Transition
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    sceneView.stop(nil)
    sceneView.play(nil)
  }
    
  // MARK: Scene
  func sceneSetup() {
    let scene = SCNScene()
    
    let length = CGFloat(15.0)
    let width = CGFloat(7.0)
    let height = CGFloat(5.0)

    // Bin setup
    
    let binColor = SCNMaterial()
    binColor.diffuse.contents = UIColor.red
    
    let binColorBlue = SCNMaterial()
    binColorBlue.diffuse.contents = UIColor.blue
    
    let binColorGreen = SCNMaterial()
    binColorGreen.diffuse.contents = UIColor.green
    
    let binBottomGeometry = SCNPlane(width: length, height: width)
    binBottomGeometry.materials = [binColor]
    let binBottom = SCNNode(geometry: binBottomGeometry)
    binBottom.rotation = SCNVector4(x: 1, y: 0, z: 0, w:Float(-Double.pi / 2))
    binBottom.position = SCNVector3(x: Float(length/2), y: 0, z: Float(width/2))
    scene.rootNode.addChildNode(binBottom)
    
    let binSideWallGeometry = SCNPlane(width: width, height: height)
    binSideWallGeometry.materials = [binColorBlue]
    let binSideWall = SCNNode(geometry: binSideWallGeometry)
    binSideWall.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float(Double.pi / 2))
    binSideWall.position = SCNVector3(x: 0, y: Float(height/2), z: Float(width/2))
    scene.rootNode.addChildNode(binSideWall)
    
    let binBackWallGeometry = SCNPlane(width: length, height: height)
    binBackWallGeometry.materials = [binColorGreen]
    let binBackWall = SCNNode(geometry: binBackWallGeometry)
    binBackWall.position = SCNVector3(x: Float(length/2), y: Float(height/2), z: 0)
    scene.rootNode.addChildNode(binBackWall)
    

    
    
    let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
    let boxNode = SCNNode(geometry: boxGeometry)
    scene.rootNode.addChildNode(boxNode)
    
    let edgeBoxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
    let edgeBoxNode = SCNNode(geometry: edgeBoxGeometry)
    edgeBoxNode.position = SCNVector3(x: Float(length), y: Float(height), z: Float(width))
    scene.rootNode.addChildNode(edgeBoxNode)
    
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLight.LightType.ambient
    ambientLightNode.light!.color = UIColor(white: 0.67, alpha: 1.0)
    scene.rootNode.addChildNode(ambientLightNode)
    
    let omniLightNode = SCNNode()
    omniLightNode.light = SCNLight()
    omniLightNode.light!.type = SCNLight.LightType.omni
    omniLightNode.light!.color = UIColor(white: 0.75, alpha: 1.0)
    omniLightNode.position = SCNVector3Make(0, 50, 50)
    scene.rootNode.addChildNode(omniLightNode)
    
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(Float(length/2), Float(height/2), Float(width) * 2)
//    cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(Double.pi / 6))
    scene.rootNode.addChildNode(cameraNode)
    
    geometryNode = boxNode
    sceneView.allowsCameraControl = true
    
//    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(_:)))
//    sceneView.addGestureRecognizer(panRecognizer)
    
    sceneView.scene = scene

  }

//    func panGesture(_ sender: UIPanGestureRecognizer) {
//        let translation = sender.translation(in: sender.view!)
//        var newAngle = (Float)(translation.x)*(Float)(Double.pi)/180.0
//        newAngle += currentAngle
//        
//        geometryNode.transform = SCNMatrix4MakeRotation(newAngle, 0, 1, 0)
//        
//        if(sender.state == UIGestureRecognizerState.ended) {
//            currentAngle = newAngle
//        }
//    }
}
