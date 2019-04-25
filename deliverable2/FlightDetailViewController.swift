//
//  FlightDetailViewController.swift
//  deliverable2
//
//  Created by Matt Kerbel on 4/21/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {

    @IBOutlet weak var flightDetailLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Event? {
        didSet {
            //configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        let detail = detailItem as! Event
        self.flightDetailLabel.text! = "Flight ID: " + (detail.eventID?.description)!
        datePicker.date = detail.timestamp!
        
    }
}

