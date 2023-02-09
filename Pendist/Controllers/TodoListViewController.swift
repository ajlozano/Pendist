//
//  ViewController.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 7/2/23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    var itemTextField = UITextField()
    let userDefaults = UserDefaults()
    let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let newItem = Item(context: self.context)
        //newItem.title = "Toni Lozano"
        //itemArray.append(newItem)

        print(dataFieldPath!)
        
        LoadData()
    }

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        // Create an alert controller pop up with an action button
        let alert = UIAlertController(title: "Add new Pendist Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // If action has been pressed
            print("success")
            
            let newItem = Item(context: self.context)
            newItem.title = self.itemTextField.text!
            newItem.done = false
            self.itemArray.append(newItem)

            self.SaveData()
    
        }
        // Add text field in alert pop-up
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add text item"
            self.itemTextField = alertTextField
        }
        alert.addAction(action)
        // Load alert in view controller
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType =  item.done ? .checkmark : .none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        SaveData()
    }
    
    func LoadData() {
        //Recover stored default local data
//        if let taskData = userDefaults.array(forKey: "Items data") as? [Item] {
//            itemArray = taskData
//        }
            
//        if let data = try? Data(contentsOf: dataFieldPath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                itemArray = try decoder.decode([Item].self, from: data)
//            } catch {
//                print("Error decoding ItemArray, \(error)")
//            }
//        }
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching the request \(error)")
        }
    }
    
    func SaveData() {
        // Save local data
        //self.userDefaults.set(self.itemArray, forKey: "Items data")
        //let encoder = PropertyListEncoder()
        
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }

}

