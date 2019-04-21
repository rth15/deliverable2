//
//  DroneModel.swift
//  deliverable2
//
//  Created by user149900 on 4/18/19.
//  Copyright © 2019 Roger Herzfeldt. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class DroneModel: NSObject, NSFetchedResultsControllerDelegate {
    //let DB Request
    //let db entity
    
    var managedObjectContext: NSManagedObjectContext? = nil
    var appDelegate: AppDelegate?
    var Drones = [DroneItem]()
    var Events = [EventItem]()
    var Repairs = [RepairItem]()
    
    let drequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Drone")
    let rrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Repair")
    let erequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Event")
    
    var _fetchedResultsController: NSFetchedResultsController<Drone>? = nil
    var fetchedResultsController: NSFetchedResultsController<Drone> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Drone> = Drone.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
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
    override init() {
        super.init()
        //managedObjectContext = UIApplication.shared.delegate
        //self.RefreshObjects()
    }
    
    func clear() -> Void {
        Drones.removeAll()
    }
    
    func count() -> Int {
        return Drones.count
    }
    
    func RefreshObjects(appDelegate: AppDelegate) -> Void {
        Drones.removeAll()
        
        //Add initial Drones (from DB?) DB
        do {
            //let context = self.fetchedResultsController.managedObjectContext
           
            let context = appDelegate.persistentContainer.viewContext
            self.appDelegate = appDelegate
            let result = try context.fetch(drequest)
            drequest.returnsObjectsAsFaults = false
            
            for data in result as! [Drone]{
                self.CreateDrone(id: data.value(forKey: "id") as! Int,
                                 name: data.value(forKey: "name") as! String)
            }
        } catch { }
    }
    
    func CreateRepair(id: Int, repairId: Int, cost: Float) {
        
    }
    
    func CreateDrone(id: Int, name: String) -> Void {
        let newDrone = DroneItem()
        newDrone.name = name
        newDrone.id = id
        self.Drones.append(newDrone)
    }
    
    func GetDrones() -> [DroneItem] {
        return self.Drones
    }
    
    func UpdateDroneName(id: Int, name: String, appDelegate: AppDelegate) -> Bool {
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Drone", in: context)
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Drone")
        request.entity = entity
        let pred = NSPredicate(format: "id = %@", NSNumber(value: id))
        request.predicate = pred
        do {
            let result = try context.fetch(request)
            if result.count > 0 {
                let manage = result[0] as! NSManagedObject
                manage.setValue(name, forKey: "name")
                
                try context.save()
            }
        } catch {}
        
        for entry in Drones {
            if entry.id == id {
                entry.name = name
            }
        }
        return true
    }
}
