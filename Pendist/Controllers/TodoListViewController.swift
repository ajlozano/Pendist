//
//  ViewController.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 7/2/23.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {

    var items = [Item]()
    
    var selectedCategory : Category? {
        didSet {
            loadItems()
            
        }
    }
    
    var itemTextField = UITextField()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
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
            newItem.parentCategory = self.selectedCategory
        
            self.items.append(newItem)

            self.saveItems()
        }
        // Add text field in alert pop-up
        alert.addTextField { field in
            field.placeholder = "Add text item"
            self.itemTextField = field
        }
        alert.addAction(action)
        // Load alert in view controller
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - tableView methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        cell.accessoryType =  items[indexPath.row].done ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        // If we want to delete CoreData itemsa
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Storage using CoreData

    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])

        } else {
            request.predicate = categoryPredicate
        }

        do {
            items = try context.fetch(request)
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
            loadItems()
            
            // Resign cursor in search
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
}

