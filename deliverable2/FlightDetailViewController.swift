//
//  FlightDetailViewController.swift
//  deliverable2
//
//  Created by Matt Kerbel on 4/21/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {

    
    var detailItem: Event?
    @IBOutlet weak var flightDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    

    @IBAction func btnConfirm(_ sender: Any) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //firstNameField.text = contact.fName
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        //contact.fName = firstNameField.text ?? ""
        
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        
        let detail = detailItem
        self.flightDetailLabel.text! = "Flight ID: " + (detail?.eventID?.description)!
        datePicker.date = Date() //detail.timestamp!
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}

