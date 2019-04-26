//
//  DetailViewController.swift
//  deliverable2
//
//  Created by user149900 on 4/17/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UINavigationControllerDelegate, NSFetchedResultsControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myPicture: UIImageView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var idText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var flightHoursText: UITextField!
    var managedObjectContext: NSManagedObjectContext? = nil
    var interactionType: String?
    var detailItem: Drone?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func UpdateName(_ sender: Any) {
        
        if detailItem != nil {
            detailItem?.dateacquired = Date()
            detailItem?.flighthours = Int32(flightHoursText.text!)!
            detailItem?.id = Int32(idText.text!)!
            detailItem?.name = nameTextField.text!
            let photo = UIImagePNGRepresentation(myPicture.image!)
            detailItem?.photo = photo
        } else {
            let context = self.fetchedResultsController.managedObjectContext
            let newDrone = Drone(context: context)
            newDrone.dateacquired = Date()
            newDrone.flighthours = Int32(flightHoursText.text!)!
            newDrone.id = Int32(idText.text!)!
            newDrone.name = nameTextField.text!
            let photo = UIImagePNGRepresentation(myPicture.image!)
            newDrone.photo = photo
        }
        // Save the context.
        do {
            try self.managedObjectContext?.save()
        } catch {
            let nserror = error as NSError
            
            print(nserror)
        }
        
        _ = navigationController?.popViewController(animated: true)
    
    }
    
    func configureView() {
        // Update the user interface for the detail item
        
        if detailItem != nil {
            interactionType = "edit"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            let dateString = dateFormatter.string(from: (detailItem?.dateacquired!)!)
            
            nameTextField.text = detailItem?.name?.description
            idText.text = detailItem?.id.description
            dateText.text = dateString
            flightHoursText.text = detailItem?.flighthours.description
            myPicture.image = UIImage(data: (detailItem?.photo!)!,scale:1.0)
            
        } else {
            interactionType = "add"
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFlights" {
                let controller = segue.destination as! FlightTableViewController
                controller.detailItem = detailItem
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
        }
    }
    
    @IBAction func pressedCamera(_ sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.cameraCaptureMode = .photo  // or .Video
            imagePicker.modalPresentationStyle = .fullScreen
        }
        else {
            imagePicker.sourceType = .photoLibrary
        }
        
        imagePicker.delegate = self
        
        present(imagePicker, animated: true, completion: nil)
    } // end pressedCamera
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        myPicture.image = image
        
        dismiss(animated: true, completion: nil)
        
    } // end imagePickerController (_:didFinish)
    
    
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

