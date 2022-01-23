//
//  ToDoTableViewController.swift
//  ToDo List
//
//  Created by Евгений Пашко on 10.12.2021.
//

import UIKit

class ToDoTableViewController: UITableViewController {
    var todos = [ToDo]()
    
    
    //MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = [
            ToDo(title: "Сделать приложение", image: UIImage(named: "coding")),
            ToDo(title: "Покормить собаку", image: UIImage(named: "dog")),
            ToDo(title: "Поставить машину в гараж", image: UIImage(named: "garage")),
        ]
        
        // Add navigation Edit button
        navigationItem.leftBarButtonItem = editButtonItem
        
    }
    
    
    //MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let todo = todos[indexPath.row]
        configure(cell, with: todo)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTodos = todos.remove(at: sourceIndexPath.row)
        todos.insert(movedTodos, at: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    
    //MARK: - Cell Content
    private func configure(_ cell: ToDoCell, with todo: ToDo ) {
        
        // Check StackView
        guard let stackView = cell.stackView else { return }
        stackView.arrangedSubviews.forEach { subview in
            stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for index in 0 ..< todo.keys.count {
            let key = todo.capitilisedKeys[index]
            let value = todo.values[index]
            
            if let stringValue = value as? String {
                
                let label = UILabel()
                label.text = "\(key): \(stringValue)"
                stackView.addArrangedSubview(label)
                
            } else if let dateValue = value as? Date {
                
                let label = UILabel()
                label.text = "\(key): \(dateValue.formattedDate)"
                stackView.addArrangedSubview(label)
                
            } else if let boolValue = value as? Bool {
                
                let label = UILabel()
                label.text = "\(key): \(boolValue ? "✅" : "⭕️" )"
                stackView.addArrangedSubview(label)
                
            } else if let imageValue = value as? UIImage {
                
                let imageView = UIImageView(image: imageValue)
                imageView.contentMode = .scaleAspectFit
                let heightConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: 200
                )
                imageView.addConstraint(heightConstraint)
                stackView.addArrangedSubview(imageView)
            }
        }
    }
    
    // Check ToDo Title from TextLabel isEmpty
    private func checkIsEmptyLables(todos: ToDo) -> Bool {
        guard !todos.title.isEmpty, todos.title.count > 1 else { return false }
        return true
    }
    
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Check identifier AddToDoItemSegue
        if segue.identifier == "AddToDoItemSegue" {
            let destination = segue.destination as! ToDoItemTableViewController
            destination.title = "New To Do Item"
            destination.navigationItem.rightBarButtonItem?.isEnabled = false
            destination.todo = ToDo.init(
                isComplete: false,
                dueDate: Date.now,
                image: UIImage.init(named: "new")
            )
            
        } else if segue.identifier == "ToDoItemSegue" {
            // Get index element
            guard let selectedIndex = tableView.indexPathForSelectedRow else { return }
            let destination = segue.destination as! ToDoItemTableViewController
            destination.navigationItem.rightBarButtonItem?.isEnabled = true
            destination.todo = todos[selectedIndex.row].copy() as! ToDo
        }
        
    }
    
    @IBAction func unwind(_ seque: UIStoryboardSegue) {
        let source = seque.source as! ToDoItemTableViewController
        guard seque.identifier == "SaveSegue" else { return }
        if let selectedIndex = tableView.indexPathForSelectedRow {
            todos[selectedIndex.row] = source.todo
            tableView.reloadRows(at: [selectedIndex], with: .automatic)
        } else {
            todos.append(source.todo)
            tableView.reloadData()
        }
        
    }
    
}


// MARK: - UITableViewDelegate
extension ToDoTableViewController /*: UITableViewDelegate */ {
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            //Remove row from table
            todos.remove(at: indexPath.row)
            
            // Reload and add animation for romoved row
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            break
        case .none:
            break
            
        @unknown default:
            break
        }
    }
}
