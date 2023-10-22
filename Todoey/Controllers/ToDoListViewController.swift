//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        // As soon as selectedCategory has a value
        didSet {
            loadItems() // READ
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Access the user's document directory and grab the first item in the array and create a custom plist called "Items.plist"
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            if #available(iOS 14.0, *) {
                var content = cell.defaultContentConfiguration()
                content.text = item.title
                cell.contentConfiguration = content
            } else {
                cell.textLabel?.text = item.title
            }
            // Add or remove a checkmark at the end of each row when selected
            // Ternary operator: value = condition ? valueTrue : valueFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items added"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(todoItems[indexPath.row])
    
        // Set property of the selected item by toggling the value. UPDATE
//        todoItems?[indexPath.row].done = !todoItems[indexPath.row].done
//
//        saveItems()
        
        // Allow the selected row to "flash select
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // This happens once the user clicks the Add Item button on the UIAlert
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        // Add a textfield to the alert pop-up
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model Manipulation Methods
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }

}

//MARK: - SearchBar Methods

//extension ToDoListViewController: UISearchBarDelegate {
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        // Query objects using CoreData
//        // "title CONTAINS %@" = Check if the title property of Item() contains %@. %@ is replaced with the text gotten from the second
//        // argument. In this case, searchBar.text!
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//        // Sort queried data
//        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//        request.sortDescriptors = [sortDescriptor]
//
//        // Run request and fetch results
//        loadItems(with: request, predicate: predicate)
//    }
//
//    // Reload list items after the search bar is emptied of text
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            // To make the cursor go away from the search bar and the keyboard disappear. Grab the main thread first
//            DispatchQueue.main.async {
//                // Now execute this code to make the cursor and keyboard go away
//                searchBar.resignFirstResponder()
//            }
//        }
//    }
//}
