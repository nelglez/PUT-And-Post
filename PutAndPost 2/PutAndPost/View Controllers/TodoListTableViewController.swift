//
//  TodoListTableViewController.swift
//  PutAndPost
//
//  Created by Nelson Gonzalez on 5/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class TodoListTableViewController: UITableViewController {
    
    @IBOutlet weak var taskTextField: UITextField!
    
    let taskController = TaskController() //An instance of the taskController. We are creating a TaskController() the () is an initializer.

    let pushMethod: PushMethod = .put
    
    override func viewDidLoad() {
        super.viewDidLoad()

            loadTasks()
     
    }
    
    private func loadTasks() {
        taskController.fetchTasks { (error) in
            if let error = error {
                //Present alert to the user that the fetch didnt work.
                print("Error: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return taskController.tasks.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)

        let task = taskController.tasks[indexPath.row]
        
        cell.textLabel?.text = task.title

        return cell
    }
    
    //Lets you set up  a custom action when you swipe on a cell
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let task = taskController.tasks[indexPath.row]
        
        let title: String
        
        if pushMethod == .put {
            title = "PUT Again"
        } else {
            title = "POST Again"
        }
        
        //What do we want to do when a user taps the action
        let againAction = UIContextualAction(style: .normal, title: title) { (_, _, handler) in
            self.taskController.push(task: task, using: self.pushMethod, completion: { (error) in
                if let error = error {
                    print("Error pusing task again: \(error)")
                    handler(false)//we couldnt perform what we need to do. It was unsuncessful
                    return
                }
                
                self.loadTasks()
                handler(true) //We successfully performed the action.
            })
        }
        
        againAction.backgroundColor = .blue
        
        let configuration = UISwipeActionsConfiguration(actions: [againAction])
        
        return configuration
    }
    
    
    @IBAction func save(_ sender: UIButton) {
        
        guard let title = taskTextField.text else { return }
        
        let task = taskController.createTask(with: title)
        
        taskController.push(task: task, using: pushMethod) { (error) in
            if let error = error {
                print("Error: \(error)")
            }
            
            self.loadTasks()
            
        }
        
      //  taskController.tasks.append(task)
        
       // loadTasks()
        
        taskTextField.text = nil
    }
    

}
