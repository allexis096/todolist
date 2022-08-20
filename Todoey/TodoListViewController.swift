//
//  ViewController.swift
//  Todoey
//
//  Created by allexis figueiredo on 19/08/22.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    let items = ["Places", "Things", "Games"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
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
}
