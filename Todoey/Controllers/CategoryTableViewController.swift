//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by allexis figueiredo on 01/09/22.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categories: [Category] = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categories[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = category.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    //MARK: - TableView Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
            tableView.reloadData()
        } catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error loading context: \(error.localizedDescription)")
        }
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { action in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            
            self.categories.append(newCategory)
            
            self.saveCategories()
        }
        
        alert.addAction(action)
        alert.addTextField { field in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
}
