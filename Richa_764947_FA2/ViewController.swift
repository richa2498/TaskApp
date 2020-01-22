//
//  ViewController.swift
//  Richa_764947_FA2
//
//  Created by Richa Patel on 2020-01-19.
//  Copyright © 2020 Richa Patel. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController ,UITextFieldDelegate {
    
    
    let date = Date()
    var formatter = DateFormatter()
    var isNew : Bool = true
    @IBOutlet weak var data_lbl: UILabel!
    
    var delegateTable : TaskTVC?
    var alert : UIAlertController?
    var presentTask: NSManagedObject?
    var isSame : Bool = false
    
    @IBOutlet weak var descriptio_txt: UITextView!
    @IBOutlet weak var title_txt: UITextField!
    @IBOutlet weak var days: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !isNew {
            loadOldData()
        }
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        
        self.view.addGestureRecognizer(tapGesture)
        
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        descriptio_txt.resignFirstResponder()
        days.resignFirstResponder()
        title_txt.resignFirstResponder()
    }
    
    @IBAction func addTask(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        
        
        if title_txt.text == "" || days.text == "" || descriptio_txt.text == ""
        {
            
            alert = UIAlertController(title: "You cant leave empty fields ", message: "add in each field", preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: "Ok", style: .destructive,handler: nil))
            self.present(alert!, animated: true)

        }else{
            

                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")

                   do {
                    if  let results = try context.fetch(fetchRequest) as? [NSManagedObject]{
                       
                           for result in results as! [NSManagedObject] {
                               let title = result.value(forKey: "title") as! String
                            if title == title_txt.text{
                                isSame = true
                            }
                     }
                    }
                   } catch {
                       print(error)
                   }

            if isSame{
               var  alert2 = UIAlertController(title: "User Alredy Exista", message: "add in each field", preferredStyle: .alert)
                alert2.addAction(UIAlertAction(title: "Ok", style: .destructive,handler: nil))
                self.present(alert2, animated: true)
            }else{
            
            

            if isNew {
                presentTask = NSEntityDescription.insertNewObject(forEntityName: "Todolist", into: context)
                data_lbl.isHidden = true

            }
            presentTask!.setValue("\(title_txt.text!)", forKey: "title")
            presentTask!.setValue(Int(days.text!) ?? 0, forKey: "noOfDays")
            presentTask!.setValue("\(descriptio_txt.text!)", forKey:"desc")
            presentTask!.setValue(date, forKey: "date")
            presentTask!.setValue(false, forKey: "isDone")
            do{
                try context.save()
            }catch{
                print(error)
            }

            delegateTable!.reloadData()
            }
        }
    }
    
    func loadOldData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        //2 this context is the manager like location manager , audio manager
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Todolist")
        request.predicate = NSPredicate(format: "title = %@", "\(delegateTable!.titleU)")
        
        
        request.returnsObjectsAsFaults = false
        //6-we find data
        do{
            let results = try context.fetch(request) as! [NSManagedObject]
            presentTask = results[0]
            
            
            //
            if let title = presentTask!.value(forKey: "title"){
                //                                       print("Name->\(title)")
                title_txt?.text = "\(title)"
                
                //newTask.setValue("\(title_txt.text!)", forKey: "title")
            }
            if let day = presentTask!.value(forKey: "noOfDays"){
                //print("Dys->\(day)")
                days?.text = "\(day)"
                
            }
            if let desc = presentTask!.value(forKey: "desc") {
                print("desc->\(desc)")
                descriptio_txt?.text = "\(desc)"
            }
            if let date = presentTask!.value(forKey: "date"){
                print(date)
                data_lbl.isHidden = false
                formatter.dateFormat = "dd ,MMM,YYYY   h:mm:ss"
                data_lbl?.text = "\(formatter.string(from: date as! Date))"
            }
            
            
            
            
        }catch{
            print("Something went Wrong!!!!🥺")
        }
    }
    
}

