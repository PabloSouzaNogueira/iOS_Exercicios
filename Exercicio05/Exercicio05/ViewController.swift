//
//  ViewController.swift
//  Exercicio05
//
//  Created by user151751 on 4/2/19.
//  Copyright © 2019 user151751. All rights reserved.
//

import UIKit

struct Todo {
    let task: String
    var isCompleted: Bool
    
    init(task:String){
        self.task = task
        self.isCompleted = false
    }
}



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var items: [Todo] = [
        Todo(task: "Terminar exercícios de iOS"),
        Todo(task: "Trocar android por iPhone"),
        Todo(task: "Comprar um Macbook")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TodoItemCell.self, forCellReuseIdentifier: "todoItem")
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoItem", for: indexPath) as? TodoItemCell else { fatalError()}
        
        cell.textLabel?.text = items[indexPath.row].task
        cell.isCompleted = items[indexPath.row].isCompleted
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        items[indexPath.row].isCompleted = items[indexPath.row].isCompleted ? false : true
        
        let itemTemp = items[indexPath.row]
        
        items.remove(at: indexPath.row)
        items.insert(itemTemp, at: indexPath.row)
        
        //tableView.reloadData()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(
            style: .destructive,
            title: "Remover",
            handler: {(action, view, completionHandler) in
                
                self.items.remove(at: indexPath.row)
                self.tableView.reloadData()
                completionHandler(true)
            })
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(
            style: .normal,
            title: self.items[indexPath.row].isCompleted ? "Desmarcar" : "Marcar",
            handler: {(action, view, completionHandler) in
                
                self.items[indexPath.row].isCompleted = self.items[indexPath.row].isCompleted ? false : true
                
                let itemTemp = self.items[indexPath.row]
                
                self.items.remove(at: indexPath.row)
                self.items.insert(itemTemp, at: indexPath.row)
                
                //tableView.reloadData()
                tableView.reloadRows(at: [indexPath], with: .fade)
                completionHandler(true)
        })
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
        
        return swipeConfiguration
    }
    
    
    
    @IBAction func adicionarItem(_ sender: Any) {
        let alertController = UIAlertController(title: "Nova tarefa", message: "Digite a nova tarefa", preferredStyle: .alert)
        
        alertController.addTextField {
            (textField) in textField.placeholder = "Tarefa"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            _ in guard let task = alertController.textFields?.first?.text else { return }
            
            self.items.append(Todo(task: task))
            self.tableView.reloadData()
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }

}

