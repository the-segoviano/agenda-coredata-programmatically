//
//  ViewController.swift
//  Agenda CoreData Programmatically
//
//  Created by Luis Segoviano on 21/01/20.
//  Copyright © 2020 The Segoviano. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {

    var people: [NSManagedObject] = []
    
    lazy var managedContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        return managedContext
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Names"
        self.view.backgroundColor = .white
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.reloadData()
        let addItem = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                      action: #selector(self.addName))
        self.navigationItem.rightBarButtonItem = addItem
        let clearDataItem = UIBarButtonItem(title: "Clear", style: .plain,
                                            target: self, action: #selector(self.clearData))
        self.navigationItem.leftBarButtonItem = clearDataItem
    }
    
    @objc func addName() {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    // Mark: UITableView's Delegate and Datasource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fetchRequest   = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
            return people.count
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: "name") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // Mark: Coredata
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKeyPath: "name")
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @objc func clearData() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.startAnimating()
        view.addSubview(spinner)
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        do {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
            let persons = try(managedContext.fetch(fetchRequest))
            for person in persons {
                managedContext.delete(person)
            }
            try(managedContext.save())
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { // simulate something is happening by 1 sec.
                self.tableView.reloadData()
                spinner.stopAnimating()
            }
        } catch let err {
            print(" err ", err)
        }
    }
    
    func fetchNameFromDisk() {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

}
