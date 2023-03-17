//
//  CategoryViewControllerTableViewController.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 9/2/23.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {

    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigatiopn controller does not exist")}
        navBar.backgroundColor = UIColor.flatRed()
    }
    
    // MARK: - Storage using CoreData
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    // MARK: - Outlet button
    
    @IBAction func AddCategoryPressed(_ sender: UIBarButtonItem) {
        var categoryTextField = UITextField()
        
        let alert = UIAlertController(title: "Add new Pendist Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = categoryTextField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        
        alert.addTextField { (field) in
            categoryTextField = field
            field.placeholder = "Add text category"
        }
        
        present(alert, animated: true, completion:  nil)
    }

    // MARK: - Table view data source
 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added"
        
        if let category = categories?[indexPath.row] {
            guard let categoryColour = UIColor(hexString: category.colour) else { fatalError()}
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        return cell
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = categories?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItem", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
}

