//
//  ViewController.swift
//  Pendist
//
//  Created by Toni Lozano Fernández on 7/2/23.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Cell 1", "Cell 2", "Cell 3"]
    var itemTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func AddButton(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new Pendist Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            // If action has been pressed
            print("success")
            self.itemArray.append(self.itemTextField.text!)
            self.tableView.reloadData()
            
        }
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Add text item"
            self.itemTextField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if(tableView.cellForRow(at: indexPath)?.accessoryType != UITableViewCell.AccessoryType.checkmark){
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
    }

}

