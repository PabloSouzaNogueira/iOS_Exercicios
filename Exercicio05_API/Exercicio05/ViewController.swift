//
//  ViewController.swift
//  Exercicio05
//
//  Created by user151751 on 4/2/19.
//  Copyright © 2019 user151751. All rights reserved.
//

import UIKit

struct Todo: Codable {
    let id: Int?
    let task: String
    var isCompleted: Bool
    
    init(task:String, id: Int?){
        self.id = id
        self.task = task
        self.isCompleted = false
    }
}

//curl -X "POST" "https://puc-dam-todolist.herokuapp.com/token" -H 'Content-Type: application/json; charset=utf-8' -d $'{"user": "LA223", "password": "LA223"}'


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let todoRepository = TodoRepository(network: NetworkService(baseUrl: "https://puc-dam-todolist.herokuapp.com"), token: "DqSUcrHJTlQ4WMvGI1AKOKT48GQTmFuFaPM5iJYTatA=")
    
    var items: [Todo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(TodoItemCell.self, forCellReuseIdentifier: "todoItem")
        todoRepository.all{ (result) in
            switch result{
                case .success(let todos):
                    self.items = todos
                    self.tableView.reloadData()
                case .error:
                    self.presentAlert(withTitle: "Erro", message: "Ops ocorreu um erro!")
            }
        }
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(
            style: .destructive,
            title: "Remover",
            handler: {(action, view, completionHandler) in
                
                self.todoRepository.delete(id: self.items[indexPath.row].id!) { (result) in
                    switch result{
                        case .success:
                            self.items.remove(at: indexPath.row)
                            self.tableView.reloadData()
                        case .error:
                            self.presentAlert(withTitle: "Erro", message: "Ops ocorreu um erro!")
                    }
                    
                    completionHandler(true)
                }
            })
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [removeAction])
        
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(
            style: .normal,
            title: self.items[indexPath.row].isCompleted ? "Desmarcar" : "Marcar",
            handler: {(action, view, completionHandler) in
                
                self.todoRepository.toggleComplete(id: self.items[indexPath.row].id!, callback: { (result) in
                    switch result{
                        case .success(let todo):
                            self.items.remove(at: indexPath.row)
                            self.items.insert(todo, at: indexPath.row)
                            self.tableView.reloadRows(at: [indexPath], with: .fade)
                        case .error:
                            self.presentAlert(withTitle: "Erro", message: "Ops ocorreu um erro!")
                    }
                    
                    completionHandler(true)
                })
            
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
            
            self.todoRepository.create(taskTitle: task, callback: { (result) in
                switch result{
                    case .success(let todo):
                        self.items.append(todo)
                        self.tableView.reloadData()
                    case .error:
                        self.presentAlert(withTitle: "Erro", message: "Ops ocorreu um erro!")
                }
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}


extension UIViewController {
    
    func presentAlert(withTitle title: String, message : String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("You've pressed OK Button")
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
