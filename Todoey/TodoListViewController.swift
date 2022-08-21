//
//  ViewController.swift
//  Todoey
//
//  Created by allexis figueiredo on 19/08/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    var items: [String] = [String]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let defaultsItems = defaults.array(forKey: "TodoListArray") as? [String] {
            items = defaultsItems
        }
    }
    
    //MARK: - Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = items[indexPath.row]
        
        cell.contentConfiguration = content
        return cell
    }
    
    //MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = textField.text, textField.text != "" else { return }
            self.items.append(text)
            
            self.defaults.set(self.items, forKey: "TodoListArray")
            
            self.tableView.reloadData()
        }
        
        let dismiss = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(dismiss)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
