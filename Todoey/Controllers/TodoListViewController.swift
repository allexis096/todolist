//
//  ViewController.swift
//  Todoey
//
//  Created by allexis figueiredo on 19/08/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    var items: [Item] = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()

        loadItems()
    }
    
    //MARK: - Tableview Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = items[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = item.title
        
        cell.contentConfiguration = content
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
    }
    
    //MARK: - Tableview Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].done = !items[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todo item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            guard let text = textField.text, textField.text != "" else { return }
            self.items.append(Item(title: text))
            
            self.saveItems()
            
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
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(self.items)
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        guard let data = try? Data(contentsOf: dataFilePath!) else { return }
        let decoder = PropertyListDecoder()
        
        do {
            items = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error decoding item array: \(error.localizedDescription)")
        }
    }
}
