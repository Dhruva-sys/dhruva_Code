//
//  AddMediList.swift
//  MediReminder
//
//  Created by Rezaul Karim on 7/6/20.
//  Copyright © 2020 Rezaul Karim. All rights reserved.
//

import UIKit
import  CoreData

class AddMediList: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var EnterMediName: UITextField!
    @IBOutlet weak var HourTime: UILabel!
    @IBOutlet weak var MinuteTime: UILabel!

    @IBOutlet weak var Time2: UILabel!
   
    
    @IBOutlet var btnArray: [UIButton]!
    
    var people: [NSManagedObject] = []
    
    var hour = 01
    var minute = 00
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    @IBAction func SelectDays(_ sender: UIButton) {
        //if sender.tag == 1{
        if sender.isSelected{
            sender.isSelected = false
        }
        else{
            sender.isSelected = true
        }
    }
    
    @IBAction func TimeSelectorSlider(_ sender: UISlider) {
        if sender.tag == 1 {
            hour = Int(sender.value)
            HourTime.text = "\(hour)"
        }
        if sender.tag == 2 {
            minute = Int(sender.value)
            MinuteTime.text = "\(minute)"
        }
    }
    
    @IBAction func AddTime(_ sender: UIButton) {
        let temp = String(hour) + ":" + String (minute)
        Time2.text = String(temp)
    }
    
    @IBAction func Save(_ sender: UIButton) {
        if !EnterMediName.text!.isEmpty {
            EnterMediName.layer.borderColor = UIColor.placeholderText.cgColor
            EnterMediName.layer.borderWidth = 1.0
            name = EnterMediName.text!
            createData()
        }
        else {
            EnterMediName.layer.borderColor = UIColor.red.cgColor
            EnterMediName.layer.borderWidth = 1.0
        }
//        performSegue(withIdentifier: "Savethis", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let send = segue.destination as! MediListTableViewController
        send.MediName = self.name
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func createData(){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Now let’s create an entity and new user records.
        let userEntity = NSEntityDescription.entity(forEntityName: "MediName", in: managedContext)!
        
        
        let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
        user.setValue(EnterMediName.text, forKeyPath: "mediName")
        user.setValue(Int32(7), forKeyPath: "totalCount")
        
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        //final, we need to add some data to our newly created record for each keys using
        //here adding 7 data with loop
        
        let userEntity2 = NSEntityDescription.entity(forEntityName: "MediList", in: managedContext)!
        
       
        
        for i in 1...7 {
            
            let user1 = NSManagedObject(entity: userEntity2, insertInto: managedContext)
            print(i)
            if i == 1 {
                user1.setValue(EnterMediName.text, forKeyPath: "mediName1")
                user1.setValue(btnArray[i-1].titleLabel?.text, forKey: "mediDay")
                user1.setValue("\(btnArray[i-1].isSelected)", forKey: "mediStatus")
                user1.setValue("\(HourTime.text ?? "01") : \(MinuteTime.text ?? "00")", forKey: "mediTime")
            }
            else {
                user1.setValue("\(EnterMediName.text ?? "")_\(i-1)", forKeyPath: "mediName1")
                user1.setValue("\(btnArray[i-1].titleLabel?.text ?? "")_\(i-1)", forKey: "mediDay")
                user1.setValue("\(btnArray[i-1].isSelected)_\(i-1)", forKey: "mediStatus")
                user1.setValue("\(HourTime.text ?? "01") : \(MinuteTime.text ?? "00")_\(i-1)", forKey: "mediTime")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        //Now we have set all the values. The next step is to save them inside the Core Data
        
//
        
    }
    
    
    
    
    
   

    
    
    
    
}
