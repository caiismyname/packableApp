import UIKit
import SceneKit
import SwiftyJSON

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
    binColor.isDoubleSided = true
    
    let binColorBlue = SCNMaterial()
    binColorBlue.diffuse.contents = UIColor.blue
    binColorBlue.isDoubleSided = true
    
    let binColorGreen = SCNMaterial()
    binColorGreen.diffuse.contents = UIColor.green
    binColorGreen.isDoubleSided = true
    
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
    
    // Lighting & Camera
    
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
    
    // Boxes
    
    let dataFromNetworking = "[{\"center\":{\"x\":12,\"y\":50,\"z\":25},\"length\":25,\"width\":50,\"height\":100},{\"center\":{\"x\":50,\"y\":25,\"z\":25},\"length\":50,\"width\":50,\"height\":50},{\"center\":{\"x\":50,\"y\":75,\"z\":25},\"length\":50,\"width\":50,\"height\":50}]"

    do {
    if let data = dataFromNetworking.data(using: String.Encoding.utf8) {

        let jsonBoxes = try JSON(data: data)
        for (key, subJson) in jsonBoxes {
            let width = subJson["width"].intValue
            let height = subJson["height"].intValue
            let length = subJson["length"].intValue
            let centerX = subJson["center"]["x"].intValue
            let centerY = subJson["center"]["y"].intValue
            let centerZ = subJson["center"]["z"].intValue
            
            let boxGeometry = SCNBox(width: CGFloat(width/10), height: CGFloat(height/10), length: CGFloat(length/10), chamferRadius: 0)
            let boxMaterial = SCNMaterial()
            boxMaterial.diffuse.contents = randomColor()
            boxGeometry.materials = [boxMaterial]
            let boxNode = SCNNode(geometry: boxGeometry)
            boxNode.position = SCNVector3(x: Float(centerX/10), y: Float(centerY/10), z: Float(centerZ/10))
            scene.rootNode.addChildNode(boxNode)
        }
    }
    } catch {
        print("error")
    }
    
    
    
    let boxGeometry = SCNBox(width: 1.0, height: 1.0, length: 1.0, chamferRadius: 0)
    let boxNode = SCNNode(geometry: boxGeometry)
    scene.rootNode.addChildNode(boxNode)
    
    


    
    geometryNode = boxNode
    sceneView.allowsCameraControl = true
    
//    let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.panGesture(_:)))
//    sceneView.addGestureRecognizer(panRecognizer)
    
    sceneView.scene = scene

  }
    
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
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
