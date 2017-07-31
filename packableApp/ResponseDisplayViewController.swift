import UIKit
import SceneKit
import SwiftyJSON

class ReponseDisplayViewController: UIViewController {
  // UI
  @IBOutlet weak var geometryLabel: UILabel!
  @IBOutlet weak var sceneView: SCNView!
  @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var contractButton: UIButton!
  
  // Geometry
  var geometryNode: SCNNode = SCNNode()
  
  // Gestures
  var currentAngle: Float = 0.0
    
  // Bin Center
    var binCenterX:Float = 0.0
    var binCenterY:Float = 0.0
    var binCenterZ:Float = 0.0

    
    var dataFromNetworking: String = ""
    
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
    
    // Boxes
    
//    // Max dimension has to be < 40. Rendering problems otherwise
//    let dataFromNetworking = "[{\"length\":40,\"width\":29.090909090909093,\"height\":40},{\"center\":{\"x\":9.090909090909092,\"y\":9.090909090909092,\"z\":9.090909090909092},\"length\":18.181818181818183,\"width\":18.181818181818183,\"height\":18.181818181818183},{\"center\":{\"x\":27.272727272727273,\"y\":9.090909090909092,\"z\":9.090909090909092},\"length\":18.181818181818183,\"width\":18.181818181818183,\"height\":18.181818181818183},{\"center\":{\"x\":9.090909090909092,\"y\":27.272727272727273,\"z\":9.090909090909092},\"length\":18.181818181818183,\"width\":18.181818181818183,\"height\":18.181818181818183},{\"center\":{\"x\":27.272727272727273,\"y\":27.272727272727273,\"z\":9.090909090909092},\"length\":18.181818181818183,\"width\":18.181818181818183,\"height\":18.181818181818183}]"
    
    do {
        if let data = dataFromNetworking.data(using: String.Encoding.utf8) {
            
            let jsonBoxes = try JSON(data: data)
//            let jsonBoxes = try JSON(data: "[{\"length\":36.36363636363636,\"width\":36.36363636363636,\"height\":40},{\"center\":{\"x\":18.18181818181818,\"y\":7.2727272727272725,\"z\":3.6363636363636362},\"length\":36.36363636363636,\"width\":10.909090909090908,\"height\":10.909090909090908},{\"center\":{\"x\":18.18181818181818,\"y\":7.2727272727272725,\"z\":14.545454545454545},\"length\":36.36363636363636,\"width\":10.909090909090908,\"height\":10.909090909090908},{\"center\":{\"x\":18.18181818181818,\"y\":7.2727272727272725,\"z\":25.454545454545453},\"length\":36.36363636363636,\"width\":10.909090909090908,\"height\":10.909090909090908},{\"center\":{\"x\":7.2727272727272725,\"y\":3.6363636363636362,\"z\":32.72727272727273},\"length\":18.18181818181818,\"width\":3.6363636363636362,\"height\":3.6363636363636362},{\"center\":{\"x\":25.454545454545453,\"y\":3.6363636363636362,\"z\":32.72727272727273},\"length\":18.18181818181818,\"width\":3.6363636363636362,\"height\":3.6363636363636362},{\"center\":{\"x\":7.2727272727272725,\"y\":7.2727272727272725,\"z\":32.72727272727273},\"length\":18.18181818181818,\"width\":3.6363636363636362,\"height\":3.6363636363636362},{\"center\":{\"x\":3.6363636363636362,\"y\":14.545454545454545,\"z\":3.6363636363636362},\"length\":7.2727272727272725,\"width\":7.2727272727272725,\"height\":7.2727272727272725},{\"center\":{\"x\":3.6363636363636362,\"y\":14.545454545454545,\"z\":10.909090909090908},\"length\":7.2727272727272725,\"width\":7.2727272727272725,\"height\":7.2727272727272725},{\"center\":{\"x\":3.6363636363636362,\"y\":14.545454545454545,\"z\":18.18181818181818},\"length\":7.2727272727272725,\"width\":7.2727272727272725,\"height\":7.2727272727272725},{\"center\":{\"x\":3.6363636363636362,\"y\":14.545454545454545,\"z\":25.454545454545453},\"length\":7.2727272727272725,\"width\":7.2727272727272725,\"height\":7.2727272727272725}]".data(using: String.Encoding.utf8)!)
            
            var firstElement = true
            
            for (_, subJson) in jsonBoxes {
                
                if (firstElement) {
                    // First element is defined to be the dimensions of the bin
                    let width = CGFloat(subJson["width"].floatValue)
                    let height = CGFloat(subJson["height"].floatValue)
                    let length = CGFloat(subJson["length"].floatValue)
                    
                    initBins(binLength: length, binWidth: width, binHeight: height, scene: scene)
                    initCamera(binLength: length, binWidth: width, binHeight: height, scene: scene)
                    firstElement = false
                    
                } else {
                    // The rest of the elements are normal boxes
                    let width = subJson["width"].floatValue
                    let height = subJson["height"].floatValue
                    let length = subJson["length"].floatValue
                    let centerX = subJson["center"]["x"].floatValue
                    let centerY = subJson["center"]["y"].floatValue
                    let centerZ = subJson["center"]["z"].floatValue
                    
                    let boxGeometry = SCNBox(width: CGFloat(length), height: CGFloat(height), length: CGFloat(width), chamferRadius: 0)
                    let boxMaterial = SCNMaterial()
                    boxMaterial.diffuse.contents = randomColor()
                    boxGeometry.materials = [boxMaterial]
                    let boxNode = SCNNode(geometry: boxGeometry)
                    boxNode.position = SCNVector3(x: Float(centerX), y: Float(centerY), z: Float(centerZ))
                    scene.rootNode.addChildNode(boxNode)
                }
            }
        }
    } catch {
        print("error")
    }
    
    sceneView.allowsCameraControl = true
    sceneView.scene = scene

  }
    
    
    // Lighting & Camera
    func initCamera(binLength: CGFloat, binWidth: CGFloat, binHeight: CGFloat, scene: SCNScene) {
        
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
        cameraNode.position = SCNVector3Make(Float(binLength/2), Float(binHeight/2), Float(binWidth) * 2)
        //    cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0, w: Float(Double.pi / 6))
        scene.rootNode.addChildNode(cameraNode)
    }
    
    
    // Bin setup
    func initBins(binLength: CGFloat, binWidth: CGFloat, binHeight: CGFloat, scene: SCNScene) {
        
        let binColor = SCNMaterial()
        binColor.diffuse.contents = UIColor.black
        binColor.isDoubleSided = true
        
        let binColorWhite = SCNMaterial()
        binColorWhite.diffuse.contents = UIColor.white
        binColorWhite.isDoubleSided = true
        
        let binColorGray = SCNMaterial()
        binColorGray.diffuse.contents = UIColor.gray
        binColorGray.isDoubleSided = true
        
        let binBottomGeometry = SCNPlane(width: binLength, height: binWidth)
        binBottomGeometry.materials = [binColor]
        let binBottom = SCNNode(geometry: binBottomGeometry)
        binBottom.rotation = SCNVector4(x: 1, y: 0, z: 0, w:Float(-Double.pi / 2))
        binBottom.position = SCNVector3(x: Float(binLength/2), y: 0, z: Float(binWidth/2))
        scene.rootNode.addChildNode(binBottom)
        
        let binSideWallGeometry = SCNPlane(width: binWidth, height: binHeight)
        binSideWallGeometry.materials = [binColorWhite]
        let binSideWall = SCNNode(geometry: binSideWallGeometry)
        binSideWall.rotation = SCNVector4(x: 0, y: 1, z: 0, w: Float(Double.pi / 2))
        binSideWall.position = SCNVector3(x: 0, y: Float(binHeight/2), z: Float(binWidth/2))
        scene.rootNode.addChildNode(binSideWall)
        
        let binBackWallGeometry = SCNPlane(width: binLength, height: binHeight)
        binBackWallGeometry.materials = [binColorGray]
        let binBackWall = SCNNode(geometry: binBackWallGeometry)
        binBackWall.position = SCNVector3(x: Float(binLength/2), y: Float(binHeight/2), z: 0)
        scene.rootNode.addChildNode(binBackWall)
        
        binCenterX = Float(binLength/2)
        binCenterY = Float(binHeight/2)
        binCenterZ = Float(binWidth/2)

    }
    
    // custom function to generate a random UIColor
    func randomColor() -> UIColor{
        let red = CGFloat(drand48())
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    @IBAction func expandAction(_ sender: UIButton) {
        for node in (sceneView.scene?.rootNode.childNodes)! {
        
            if (node.position.x > binCenterX) {
                node.position.x += abs(node.position.x - binCenterX)/2
            } else {
                node.position.x -= abs(node.position.x - binCenterX)/2
            }
            
            if (node.position.y > binCenterY) {
                node.position.y += abs(node.position.y - binCenterY)/2
            } else {
                node.position.y -= abs(node.position.y - binCenterY)/2
            }
            
            if (node.position.z > binCenterZ) {
                node.position.z += abs(node.position.z - binCenterZ)/2
            } else {
                node.position.z -= abs(node.position.z - binCenterZ)/2
            }
        }
    }
    
    @IBAction func contractAction(_ sender: UIButton) {
        
        for node in (sceneView.scene?.rootNode.childNodes)! {
            
            if (node.position.x > binCenterX) {
                node.position.x -= abs(node.position.x - binCenterX)/3
            } else {
                node.position.x += abs(node.position.x - binCenterX)/3
            }
            
            if (node.position.y > binCenterY) {
                node.position.y -= abs(node.position.y - binCenterY)/3
            } else {
                node.position.y += abs(node.position.y - binCenterY)/3
            }
            
            if (node.position.z > binCenterZ) {
                node.position.z -= abs(node.position.z - binCenterZ)/3
            } else {
                node.position.z += abs(node.position.z - binCenterZ)/3
            }
        }
        
    }
    
    
    
}
