//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    // Create an object of the interface to the user's default database, where key-value pairs are stored
    // persistently across app launches
    // let defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Access the user's document directory and grab the first item in the array and create a custom plist called "Items.plist"
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        // READ
        loadItems()
        
    }
    
    //MARK: - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.text = item.title
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = item.title
        }
        
        // Add or remove a checkmark at the end of each row when selected
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(itemArray[indexPath.row])
    
        // Set property of the selected item by toggling the value. UPDATE
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // DELETE (The order matters, so your app doesn't crash
        // context.delete(itemArray[indexPath.row])
        // itemArray.remove(at: indexPath.row)
        
        saveItems()
        
        // Allow the selected row to "flash select
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // This happens once the user clicks the Add Item button on the UIAlert
            
            // Initialise CoreData Item (CREATE)
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            self.itemArray.append(newItem)
            
            // Call saveItems to update the custom plist
            self.saveItems()
            
            // Save the updated itemArray to the user's defaults
            // self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
    
    func saveItems() {
        
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        // Update items-display in the tableview &
        // Force the Tableview Datasource Methods to run again after didSelectRowAt, so as to enable the .checkmark accesory
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }

}

//MARK: - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Query objects using CoreData
        // "title CONTAINS %@" = Check if the title property of Item() contains %@. %@ is replaced with the text gotten from the second
        // argument. In this case, searchBar.text!
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // Sort queried data
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        // Run request and fetch results
        loadItems(with: request)
    }
    
    // Reload list items after the search bar is emptied of text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // To make the cursor go away from the search bar and the keyboard disappear. Grab the main thread first
            DispatchQueue.main.async {
                // Now execute this code to make the cursor and keyboard go away
                searchBar.resignFirstResponder()
            }
        }
    }
}
