//
//  HomeViewController.swift
//  packableApp
//
//  Created by David Cai on 7/29/17.
//  Copyright © 2017 David Cai. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!
    
    var responseString: String = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {}
    
    @IBAction func postAction(_ sender: UIButton) {
        var request = URLRequest(url: URL(string: "https://tranquil-ravine-99615.herokuapp.com/hello")!)
        request.httpMethod = "POST"
        let postBody = "[{x: 20, y: 20, z: 40}, {x: 30, y: 5, z: 5}, {x: 20, y: 20, z: 20}, {x: 10, y: 20, z: 20}, {x: 20, y: 10, z: 10}, {x: 20, y: 20, z: 20}, {x: 10, y: 20, z: 10}, {x: 20, y: 10, z: 10}, {x: 20, y: 20, z: 20}, {x: 20, y: 20, z: 20}, {x: 20, y: 20, z: 20}]"
        request.httpBody = postBody.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
            }
            
            self.responseString = String(data: data, encoding: .utf8)!
            print(self.responseString)

        }
        task.resume()
    }

    
     //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationVC = segue.destination as? ReponseDisplayViewController {
            destinationVC.dataFromNetworking = self.responseString
        }
        
    }
 

}
