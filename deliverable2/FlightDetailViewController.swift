//
//  FlightDetailViewController.swift
//  deliverable2
//
//  Created by Matt Kerbel on 4/21/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController {

    @IBOutlet var flightDetailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: Event? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = flightDetailLabel {
                label.text = "Flight ID: " + (detail.eventID?.description)!
            }
        }
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
