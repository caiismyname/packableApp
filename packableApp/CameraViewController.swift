//
//  CameraViewController.swift
//  packableApp
//
//  Created by David Cai on 7/29/17.
//  Copyright © 2017 David Cai. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let reuseIdentifier = "photoCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkCameraPermission()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: CollectionView
    
    

    //UICollectionViewDelegateFlowLayout methods
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 4;
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat
    {
        return 1;
    }
    
    
    //UICollectionViewDatasource methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! PhotoDisplayCellViewControllerCollectionViewCell
        
        cell.backgroundColor = UIColor.black
        cell.imageView.image = photos[indexPath.row]
    
        return cell
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    // MARK: Camera shit
    
    
    
    func checkCameraPermission() {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        switch authStatus {
            case .authorized: takePhotoAction(takePhotoButton)
            case .denied: alertPromptToAllowCameraAccessViaSettings()
            case .notDetermined: permissionPrimeCameraAccess()
            default: permissionPrimeCameraAccess()
        }
    }
    
    func alertPromptToAllowCameraAccessViaSettings() {
        let alert = UIAlertController(title: "PackABLE would Like To Access the Camera", message: "Please grant permission to use the Camera so that you can pack your shit.", preferredStyle: .alert )
        alert.addAction(UIAlertAction(title: "Open Settings", style: .cancel) { alert in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        })
        present(alert, animated: true, completion: nil)
    }
    
    func permissionPrimeCameraAccess() {
        if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
            AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                DispatchQueue.main.async() {
                    self.checkCameraPermission()
                }
            }
        }
    }

    @IBAction func takePhotoAction(_ sender: UIButton) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photos.append(pickedImage)
            collectionView.reloadData()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // MARK: Sending photos to server
    
    @IBAction func sendToServer(_ sender: UIButton) {
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
