//
//  mediDetailsViewController.swift
//  MediReminder
//
//  Created by Dhruva's mac on 11/06/20.
//  Copyright © 2020 Rezaul Karim. All rights reserved.
//

import UIKit
import CoreData

class mediDetailsViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var EnterMediName: UITextField!

    @IBOutlet weak var Time2: UILabel!
   
    
    @IBOutlet var btnArray: [UIButton]!
    
    var people: [NSManagedObject] = []
    
    
    var hour = 01
    var minute = 00
    var name = ""
    var totalCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveData()
    }
    
    @IBAction func SelectDays(_ sender: UIButton) {
        //if sender.tag == 1{
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
        //}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let send = segue.destination as! MediListTableViewController
        send.MediName = self.name
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func retrieveData() {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
     
        //Prepare the request of type NSFetchRequest  for the entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MediList")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            var count = 0
            var name1 = name
            print(result)

            var bool : String
            for data in result as! [NSManagedObject] {
                
                bool = data.value(forKey: "mediStatus") as! String
                if count > 0 {
                    name1 = "\(name)_\(count)"
                    bool.removeLast()
                    bool.removeLast()
                }
                
                print(name)
                if data.value(forKey: "mediName1") as! String == name1 {
                    
                    if count == 0 {
                        Time2.text = data.value(forKey: "mediTime") as? String
                        EnterMediName.text = data.value(forKey: "mediName1") as? String
                    }
                    if count != 6 {
                        
                        if bool == "true" {
                            btnArray[count].isHidden = false
                        } else {
                            btnArray[count].isHidden = true
                        }
                    }
                    
                    count = count + 1
                }
    
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    
    
    
    
   

    
    
    
    
}
