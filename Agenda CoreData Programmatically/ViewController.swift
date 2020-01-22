//
//  ViewController.swift
//  Agenda CoreData Programmatically
//
//  Created by Luis Segoviano on 21/01/20.
//  Copyright © 2020 The Segoviano. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var people: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Names"
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.backgroundColor = .white
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addName))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc func addName(){
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.people.append(nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row]
        return cell
    }
    

}
