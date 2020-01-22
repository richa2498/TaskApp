//
//  TaskTVC.swift
//  Richa_764947_FA2
//
//  Created by Richa Patel on 2020-01-20.
//  Copyright © 2020 Richa Patel. All rights reserved.
//

import UIKit
import CoreData

class TaskTVC: UITableViewController,UISearchBarDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    @IBOutlet weak var searchBar: UISearchBar!
    var index : Int?
    var results : [NSManagedObject]?
    var filterResult : [NSManagedObject]?
    var titleU : String = ""
   
   override func viewDidLoad() {
        super.viewDidLoad()
        
            searchBar.delegate = self
            definesPresentationContext = true
            loadCoreData()
            self.navigationItem.rightBarButtonItem = self.editButtonItem
       
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         
           let contex = appDelegate.persistentContainer.viewContext
                  
           let getreq = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
            do{
                   if !searchText.isEmpty{
                       getreq.predicate = NSPredicate(format: "title contains[c] %@", searchText)
                       }
                   if results is [NSManagedObject]{
                          results = try contex.fetch(getreq) as! [NSManagedObject]
                          tableView.reloadData()
                   }
               }catch{
                      print(error)
                  }
               
         
       }
    
    @IBAction func byDate(_ sender: UIButton) {
      
        let contex = appDelegate.persistentContainer.viewContext
        
        let getreq = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        
        getreq.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            do{
                results = try contex.fetch(getreq) as! [NSManagedObject]
                tableView.reloadData()
                
            }catch{
                print(error)
            }
    }
    
    @IBAction func byTitle(_ sender: UIButton) {
       
        let contex = appDelegate.persistentContainer.viewContext
        
        let getreq = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        
        getreq.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            do{
                results = try contex.fetch(getreq) as! [NSManagedObject]
                tableView.reloadData()
                
            }catch{
                print(error)
            }
        
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
        
          var task  = results![indexPath.row]
        
           let cell = tableView.dequeueReusableCell(withIdentifier: "task") as! UITableViewCell
           let managedContext = appDelegate.persistentContainer.viewContext
           cell.textLabel?.text = task.value(forKey: "title") as! String
        
           var days = task.value(forKey: "noOfDays") as! Int
           cell.detailTextLabel!.text = "Days : \(days)"
            
              if (task.value(forKey: "noOfDays") as! Int) == 0 {
                task.setValue(true, forKey: "isDone")
                cell.backgroundColor = .cyan
                        do{
                              try managedContext.save()
                           }catch{
                                print(error)
                            }
                       return cell
            }
          cell.backgroundColor = .white
          return cell
    }
    
    
    func loadCoreData() {
      
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
                }
            
        } catch {
            print(error)
        }

    }
    
    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source as! ViewController

    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //loadCoreData()
        //tableView.reloadData()
    }
   
    func reloadData(){
        loadCoreData()
        tableView.reloadData()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView,editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
            let managedContext = appDelegate.persistentContainer.viewContext
            var currentResult = self.results![indexPath.row]
            let deleteTitle = NSLocalizedString("Delete", comment: "Delete action")
            let deleteAction = UITableViewRowAction(style: .destructive,title: deleteTitle) { (action, indexPath) in
        
                    managedContext.delete(currentResult)
                    self.results?.remove(at: indexPath.row)
                           do{
                               try managedContext.save()
                           }catch
                           {
                               print(error)
                           }
                           self.tableView.deleteRows(at: [indexPath], with: .fade)
                           tableView.reloadData()
              }
        
        

            let addNumber = NSLocalizedString("Decrease Day", comment: "desc action")
            let increaseNum = UITableViewRowAction(style: .normal,title: addNumber) { (action, indexPath) in
       
                  
            let days = currentResult.value(forKey: "noOfDays") as! Int - 1
            currentResult.setValue(days, forKey: "noOfDays")
                         do{
                             try managedContext.save()
                         }catch
                         {
                             print(error)
                         }

                         tableView.reloadData()
           }
        
           increaseNum.backgroundColor = .black
            
            if currentResult.value(forKey: "isDone") as! Bool{
                return [deleteAction]
            }
            else{
          
               return [increaseNum, deleteAction]
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
                    }else{
                        index = tableView.indexPath(for: sender as! UITableViewCell)?.row
                        let sendIt = results![index!]
                        titleU = sendIt.value(forKey: "title") as! String
                        update.isNew = false
                }
            
                  
              }
       
    }
  

}
