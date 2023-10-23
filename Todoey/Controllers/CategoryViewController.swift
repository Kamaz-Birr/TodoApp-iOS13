//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Haldox on 20/10/2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import Chameleon

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    // This Results data type is an auto-updating container type from Realm, thus there is no need to explicitly append new values
    // in the addButtonPressed fuction. Option-click 'Results' for more info
    var categoryArray: Results<Category>?
    let defaultColour = "1D9BF6"

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadCategory()
        
        // Increase the size of the cells
        tableView.rowHeight = 80.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation Controller does not exist")
        }
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(hexString: defaultColour)
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: appearance.backgroundColor!, isFlat: true)]
        // Change the reduced title text on scrolling to match the colour of the large title text
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(contrastingBlackOrWhiteColorOn: appearance.backgroundColor!, isFlat: true)]
        navBar.standardAppearance = appearance
        navBar.scrollEdgeAppearance = navBar.standardAppearance
    }
    
    //MARK: - Add New Category

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.bgColour = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        
        // Add a textfield to the alert pop-up
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If categories is not nil, then return .count, else, return 1. This type of syntax is called the Nil Coalescing Operator
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Tap into the super class
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        let category = categoryArray?[indexPath.row]
        
        // If for some reason no BG colour is found in the optional value category, use the default colour
        cell.backgroundColor = UIColor(hexString: category?.bgColour ?? defaultColour)
        
        if #available(iOS 14.0, *) {
            var content = cell.defaultContentConfiguration()
            content.textProperties.color = UIColor(contrastingBlackOrWhiteColorOn: cell.backgroundColor!, isFlat: true)
            content.text = category?.name ?? "No Categories Added Yet"
            cell.contentConfiguration = content
        } else {
            cell.textLabel?.text = category?.name ?? "No Categories Added Yet"
        }
        
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    // This function runs before the segue is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Create a reference to the destination viewcontroller. In this case, the destination viewcontroller is the ToDoListViewController
        let destinationVC = segue.destination as! ToDoListViewController
        
        // Grab the category that corresponds to the selected cell
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving Category \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categoryArray = realm.objects(Category.self)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let category = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(category)
                }
            } catch {
                print("Error deleting category \(error)")
            }
        }
    }
    
}
