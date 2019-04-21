//
//  DetailViewController.swift
//  deliverable2
//
//  Created by user149900 on 4/17/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var DataModel: DroneModel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = "Drone ID: " + detail.id.description
            }
            
            if (nameTextField) != nil {
                nameTextField.text = detail.name?.description
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DataModel = appDelegate.droneModel
        
        //DataModel.GetDrones() //Do Something load screen whatever
        
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Drone? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func UpdateName(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let id = (detailItem?.id)!
        let name = (nameTextField.text?.description)!
        let _ = appDelegate.droneModel.UpdateDroneName(id: Int(id), name: name, appDelegate: appDelegate)
    }
    
    
    
}

