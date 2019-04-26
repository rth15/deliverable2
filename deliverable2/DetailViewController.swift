//
//  DetailViewController.swift
//  deliverable2
//
//  Created by user149900 on 4/17/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var flightHoursText: UITextField!
    var managedObjectContext: NSManagedObjectContext? = nil
    
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
        
        if detailItem != nil {
            detailItem?.dateacquired = Date()
            detailItem?.flighthours = Int32(flightHoursText.text!)!
            detailItem?.id = Int32(idText.text!)!
            detailItem?.name = nameTextField.text!
        } else {
            let context = self.fetchedResultsController.managedObjectContext
            let newDrone = Drone(context: context)
            newDrone.dateacquired = Date()
            newDrone.flighthours = Int32(flightHoursText.text!)!
            newDrone.id = Int32(idText.text!)!
            newDrone.name = nameTextField.text!
        }
        // Save the context.
        do {
            try self.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            
            print(nserror)
        }
        
        _ = navigationController?.popViewController(animated: true)
        
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let id = (detailItem?.id)!
//        let name = (nameTextField.text?.description)!
//        let _ = appDelegate.droneModel.UpdateDroneName(id: Int(id), name: name, appDelegate: appDelegate)
    }
    
    
    //MARK: Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Drone> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Drone> = Drone.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        
        //        let searchString =
        //        fetchRequest.predicate = NSPredicate(format: "eventID == %@", searchString)
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.managedObjectContext = appDelegate.persistentContainer.viewContext
            
        }
        
        // Create FetchedResultsController
        
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController<Drone>? = nil
    
    
}

