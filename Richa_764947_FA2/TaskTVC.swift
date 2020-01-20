//
//  TaskTVC.swift
//  Richa_764947_FA2
//
//  Created by Richa Patel on 2020-01-20.
//  Copyright © 2020 Richa Patel. All rights reserved.
//

import UIKit
import CoreData

class TaskTVC: UITableViewController {
    
    var index : Int?
    var results : [NSManagedObject]?
    var titleU : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCoreData()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return results?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "task") as! UITableViewCell
        var task  = results![indexPath.row]
        cell.textLabel?.text = task.value(forKey: "title") as! String
       var days = task.value(forKey: "noOfDays") as! Int
        cell.detailTextLabel!.text = "Days : \(days)"
        
        
        
        return cell
    }
    func loadCoreData() {
      
        // create an instance of app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // second step is context
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")

        do {
            results = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
                for result in results as! [NSManagedObject] {
                    let title = result.value(forKey: "title") as! String
                    let days = result.value(forKey: "noOfDays") as! Int
                    let date = result.value(forKey: "date") as! Date
                    let desc = result.value(forKey: "desc") as! String
                    let done = result.value(forKey: "isDone") as! Bool

                   // tasks.append(Tasks(title: title, desc: desc, date: date, noOfDays: Int(days), isDone: done))
                    
                }
            
        } catch {
            print(error)
        }

    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! ViewController
        
        
        
        
        // Use data from the view controller which initiated the unwind segue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadCoreData()
        tableView.reloadData()
    }
   

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            results?.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

 
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        var temp = results![fromIndexPath.row]
        results![fromIndexPath.row] = results![to.row]
        results![to.row] = temp
        
        tableView.reloadData()

    }
    

    
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    

  
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let update = segue.destination as? ViewController {
            update.delegateTable = self
            if ((sender as? UIBarButtonItem) != nil){
                update.isNew = true
            }
            else{index = tableView.indexPath(for: sender as! UITableViewCell)?.row
            var sendIt = results![index!]
            titleU = sendIt.value(forKey: "title") as! String
            update.isNew = false
            }
            
                  
              }
       
    }
  

}
