//
//  UpdateTask.swift
//  Richa_764947_FA2
//
//  Created by Richa Patel on 2020-01-20.
//  Copyright © 2020 Richa Patel. All rights reserved.
//

import UIKit
import CoreData

class UpdateTask: UIViewController {

    var delegateTable : TaskTVC?
    
    @IBOutlet weak var lrr: UILabel!
    @IBOutlet weak var update_desc: UITextView!
    @IBOutlet weak var update_days: UITextField!
    @IBOutlet weak var update_title: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("loded")
        // Do any additional setup after loading the view.
       
         let appDelegate = UIApplication.shared.delegate as! AppDelegate
              
              
              //2 this context is the manager like location manager , audio manager
              let context = appDelegate.persistentContainer.viewContext
                let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
                request.predicate = NSPredicate(format: "title = %@", "\(delegateTable!.titleU)")
       
             
                request.returnsObjectsAsFaults = false
                //6-we find data
                do{
                    let results = try context.fetch(request)
                    if results.count > 0{
                        for result in results as! [NSManagedObject]{
        //
                            if let title = result.value(forKey: "title") {
                                print("Name->\(title)")
                                update_title?.text = "\(title)"
                                result.setValue("\(update_title.text!)", forKey: "title")
                                 //newTask.setValue("\(title_txt.text!)", forKey: "title")
                            }
                            if let days = result.value(forKey: "noOfDays"){
                                print("Dys->\(days)")
                                update_days?.text = "\(days)"
                                result.setValue(Int(update_days.text!), forKey: "noOfDays")
                            }
                            if let desc = result.value(forKey: "desc") {
                                print("desc->\(desc)")
                                update_desc?.text = "\(desc)"
                                result.setValue("\(update_desc.text!)", forKey: "desc")
                               

                                
                                do{
                                    try context.save()
                                }catch{
                                    print(error)
                                }
                             }
        
        //                        do{
        //                            try context.save()
        //                        }catch{
        //                            print("cant delete")
        //                        }
        //                        print(name)
        //                    }
                    }
                    }
                    
                
                }catch{
                    print("Something went Wrong!!!!🥺")
                }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
