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
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let userDefaults = UserDefaults()
    //let dataFieldPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LoadData()
    }
    
    // MARK: - Outlet button

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        // Create an alert controller pop up with an action button
        let alert = UIAlertController(title: "Add new Pendist Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // If action has been pressed
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
    
    // MARK: - tableView meethods
    
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
    
    // MARK: - Storage using CoreData

    func SaveData() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func LoadData(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching the request \(error)")
        }
        
        tableView.reloadData()
    }
}

// MARK: - Search Bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            LoadData()
            
            // Resign cursor in search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        LoadData(with: request)
    }
}

