//
//  MediListTableViewController.swift
//  MediReminder
//
//  Created by Rezaul Karim on 5/6/20.
//  Copyright © 2020 Rezaul Karim. All rights reserved.
//

import UIKit
import  CoreData

class MediListTableViewController: UITableViewController {
    
    var MediName = ""
    
    var MediItem: [String] = []
    var MediItemCount: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Medi List"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ThisCell")
        
       
//        MediItem.append(MediName)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
         retrieveData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MediItem.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = MediItem[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMedi", sender: self)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            deleteData(string: MediItem[indexPath.row])
//            MediItem.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    func retrieveData() {
           
           //As we know that container is set up in the AppDelegates so we need to refer that container.
           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
           
           //We need to create a context from this container
           let managedContext = appDelegate.persistentContainer.viewContext
           
        MediItem = []
           //Prepare the request of type NSFetchRequest  for the entity
           let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MediName")
        
           //
           do {
               let result = try managedContext.fetch(fetchRequest)
               for data in result as! [NSManagedObject] {
                print(data.value(forKey: "mediName") as! String)
                MediItem.append(data.value(forKey: "mediName") as! String)
                MediItemCount = data.value(forKey: "totalCount") as! Int
               }
               
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
           } catch {
               
               print("Failed")
           }
       }
    
    func deleteData(string:String){
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        //We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MediName")
        fetchRequest.predicate = NSPredicate(format: "mediName = %@", string)
       
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = test[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                retrieveData()
            }
            catch
            {
                print(error)
            }
            
        }
        catch
        {
            print(error)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMedi" {
            let destinationVC = segue.destination as! mediDetailsViewController
            destinationVC.name = MediItem[tableView.indexPathForSelectedRow!.row]
            destinationVC.totalCount = MediItemCount
        }
    }
}
