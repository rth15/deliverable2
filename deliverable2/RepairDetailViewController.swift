

//
//  RepairDetailViewController.swift
//  deliverable2
//
//  Created by user149900 on 4/17/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit
import CoreData

class RepairDetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var repnav: UINavigationBar!
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var costTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var repairDescTextField: UITextField!
    
    @IBOutlet var backBtn: UIBarButtonItem!
    var DataModel: DroneModel!
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = "Drone Repair ID: " + detail.repid.description
            }
            
            if (costTextField) != nil {
                costTextField.text = detail.cost.description
            }
            
            if (dateTextField) != nil {
                dateTextField.text = detail.date?.description
            }
            
            if (repairDescTextField) != nil {
                repairDescTextField.text = detail.repairdetails?.description
            }
            
        }
    }
    @IBAction
    func backAction() {
        
        self.view?.window?.rootViewController?.dismiss(animated: (true), completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.action = #selector(backAction)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DataModel = appDelegate.droneModel
        
        
        
        //DataModel.GetDrones() //Do Something load screen whatever
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Repair {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    @IBAction func UpdateRepairDetails(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let id = (detailItem?.repid)!
        let cost = Float(Double((costTextField.text?.description)!)!)
        let repairdets = (repairDescTextField.text?.description)!
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Repair", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Repair")
        request.entity = entity
        let pred = NSPredicate(format: "repid = %@", NSNumber(value: id))
        request.predicate = pred
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let manage = result[0] as! NSManagedObject
                manage.setValue(cost, forKey: "cost")
                manage.setValue(repairdets, forKey: "repairdetails")
                try context.save()
            }
        } catch {}
    }
}


