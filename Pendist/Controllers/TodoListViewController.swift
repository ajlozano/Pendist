//
//  ViewController.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 7/2/23.
//

import UIKit
import CoreData
import RealmSwift

class TodoListViewController: UITableViewController {

    var items: Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    // MARK: - tableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        
        if let item = items?[indexPath.row] {
            
            cell.textLabel?.text = item.name
            cell.accessoryType =  item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No items added"
        }
  
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if let item = items?[indexPath.row] {
            
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Outlet button

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        
        // Create an alert controller pop up with an action button
        let alert = UIAlertController(title: "Add new Pendist Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // If action has been pressed
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.name = itemTextField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch  {
                    print("Error saving new items, \(error)")
                }
            }

            self.tableView.reloadData()
        }
        // Add text field in alert pop-up
        alert.addTextField { field in
            field.placeholder = "Add text item"
            itemTextField = field
        }
        
        alert.addAction(action)
        // Load alert in view controller
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Storage using CoreData
    
    func loadItems() {
        items = selectedCategory?.items.sorted(byKeyPath: "name", ascending: true)
        
        tableView.reloadData()
    }
}

// MARK: - Search Bar delegate methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            loadItems()
            
            // Resign cursor in search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
}

