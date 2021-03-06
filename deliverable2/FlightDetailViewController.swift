//  PROGRAMMER: Matthew Kerbel/Roger Herzfeldt

//  PANTHERID:     1763392

//  CLASS:          COP 465501

//  INSTRUCTOR:     Steve Luis  Online

//  ASSIGNMENT:     Deliverable 2

//  DUE:            4/26/19

//

import UIKit
import CoreData

class FlightDetailViewController: UIViewController, NSFetchedResultsControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var flightDetailLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var flightIdLabel: UITextField!
    @IBOutlet weak var flightDurationLabel: UITextField!
    @IBOutlet weak var flightLocationLabel: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    var managedObjectContext: NSManagedObjectContext? = nil
    var interactionType: String?
    var detailItem: Event?
    var droneItem: Drone?
    var droneID: Int32?

    @IBAction func dateChanged(_ sender: Any) {
        let dateFormatterDate = DateFormatter()
        let dateFormatterTime = DateFormatter()
        dateFormatterDate.dateStyle = .full
        dateFormatterTime.timeStyle = .short
        let dateString = dateFormatterDate.string(from: datePicker.date)
        let timeString = dateFormatterTime.string(from: datePicker.date)
        dateLabel.text = "Date: " + dateString
        timeLabel.text = "Time: " + timeString
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if interactionType == "add" {
            commitChanges()
        } else {
            commitChanges()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        _ = fetchedResultsController
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        droneID = droneItem?.id
        if detailItem != nil {
            interactionType = "edit"
            configureEditView()
        } else {
            interactionType = "add"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
    }
    
    func configureEditView() {
        // Update the user interface for the detail item.
            let detail = detailItem
            let dateFormatterDate = DateFormatter()
            let dateFormatterTime = DateFormatter()
            dateFormatterDate.dateStyle = .full
            dateFormatterTime.timeStyle = .short
            let dateString = dateFormatterDate.string(from: (detail?.timestamp!)!)
            let timeString = dateFormatterTime.string(from: (detail?.timestamp!)!)
        
            flightDetailLabel.text! = "Flight ID: "
            flightIdLabel.text = detail?.eventID?.description
            datePicker.date = (detail?.timestamp!)!
            dateLabel.text = "Date: " + dateString
            timeLabel.text = "Time: " + timeString
            flightDurationLabel.text! = (detail?.duration.description)!
            flightLocationLabel.text = detail?.location?.description
    }
    
    func commitChanges() {
        
        let context = self.fetchedResultsController.managedObjectContext
        if detailItem != nil {
            detailItem?.timestamp = datePicker.date
            detailItem?.eventID = flightIdLabel.text
            detailItem?.duration = Int64(flightDurationLabel.text!)!
            detailItem?.location = flightLocationLabel.text
            detailItem?.droneID = droneID!
            
        } else {
            let duration = Int64(flightDurationLabel.text!)
            let newEvent = Event(context: context)
            newEvent.timestamp = datePicker.date
            newEvent.eventID = flightIdLabel.text
            newEvent.duration = duration!
            newEvent.location = flightLocationLabel.text
            newEvent.droneID = droneID!
        }
        // Save the context.
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            
            print(nserror)
        }
    }
    
    //MARK: Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Event> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Event> = Event.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        if self.managedObjectContext == nil {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.managedObjectContext = appDelegate.persistentContainer.viewContext
        }
        
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: "Event", in: self.managedObjectContext!)
        
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
    var _fetchedResultsController: NSFetchedResultsController<Event>? = nil
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        for textField in self.view.subviews where textField is UITextField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    // dismiss keyboard
    @objc
    func hideKeyboard() {
        view.endEditing(true)
    }
    
}

