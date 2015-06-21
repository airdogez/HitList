//
//  ViewController.swift
//  HitList
//
//  Created by Alumnos on 6/20/15.
//  Copyright (c) 2015 Alumnos. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource{
    
    //var names = [String]()
    var people = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addName(sender: AnyObject) {
        var alert = UIAlertController(title: "New name", message: "Add a new name", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {(action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0] as UITextField
            //self.names.append(textField.text)
            self.saveName(textField.text)
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: {(action: UIAlertAction!) -> Void in
        })
        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) -> Void in})
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "\"The List\""
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return names.count
        return people.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell!
        //cell.textLabel.text = names[indexPath.row]
        let person = people[indexPath.row]
        cell.textLabel.text = person.valueForKey("name") as String?
        return cell
    }
    
    func saveName(name: String){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate!
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("Person", inManagedObjectContext: managedContext)
        let person = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        person.setValue(name, forKey: "name")
        var error: NSError?
        if !managedContext.save(&error){
            println("Could not save \(error), \(error?.userInfo)")
        }
        people.append(person)
    }
    
    func restoreFromStore(){
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate!
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "Person")
        var error: NSError?
        let fetchResult = managedContext.executeFetchRequest(fetchRequest, error: &error) as [NSManagedObject]!
        if let results = fetchResult{
            people = results
        }
        else{
            println("Could not fetch \(error), \(error!.userInfo)")
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.restoreFromStore()
    }
}