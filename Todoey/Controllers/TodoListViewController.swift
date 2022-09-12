//
//  ViewController.swift
//  Todoey
//
//  Created by allexis figueiredo on 19/08/22.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    var items: [Item] = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .white
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
            
            let newItem = Item(context: self.context)
            newItem.title = text
            newItem.parentCategory = self.selectedCategory
            
            self.items.append(newItem)
            
            self.saveItems()
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
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
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
            tableView.reloadData()
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
    }
}

//MARK: - SearchBarDelegate

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
