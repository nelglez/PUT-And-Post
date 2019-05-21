//
//  TaskController.swift
//  PutAndPost
//
//  Created by Nelson Gonzalez on 5/15/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

enum PushMethod: String {
    case post = "POST"
    case put = "PUT"
}

class TaskController {
    
    enum HTTPMethods: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
    }
    
   
    
    private let baseUrl = URL(string: "https://put-and-post.firebaseio.com/")!
    //The data source for table view
    var tasks: [Task] = []
    
    func createTask(with title: String) -> Task {
        let task = Task(title: title)
        return task
    }
    
    func fetchTasks(completion: @escaping (Error?) -> Void) {
        //Set up the URL
        
        //Make the request
            // - URL
            // - Body
            // - HTTP Method
        
        //URLSessionDataTask (and resume)
        
        // Decode the data into model object(s).
        
            //Will put the "." in the url for you.
        let requestUrl = baseUrl.appendingPathExtension("json")
        
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = HTTPMethods.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                NSLog("Error fetching tasks: \(error)")
                completion(error)
            }
            
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            
            do {
                let decoder = JSONDecoder()
                
                let tasks = try decoder.decode([String: Task].self, from: data)
                //Array(tasks.values) same as below
                self.tasks = tasks.map({ $0.value })
                completion(nil)
            } catch {
                NSLog("Error decoding tasks: \(error)")
                completion(error)
            }
            
        }.resume()
    }
    
    // POST is used to create a new resource
    
    // PUT is used to update an existing resource, but can also create new resources
    
    func push(task: Task, using method: PushMethod, completion: @escaping (Error?) -> Void) {
        
        var requestUrl = baseUrl
        
        if method == .put {
            //we need to add a unique path component to the url or it will overwrite everything at the base url
            
            requestUrl.appendPathComponent(task.identifier)
        }
        
        requestUrl.appendPathExtension("json")
        
        var request = URLRequest(url: requestUrl)
        
        request.httpMethod = method.rawValue //"PUT" or "POST"
        
        do {
            let jsonEncoder = JSONEncoder()
            
            request.httpBody = try jsonEncoder.encode(task)//Some 'data' we want to send to api through the message body. Turns Task object into data
          //  completion(nil)
        } catch {
            NSLog("Error encoding the task: \(error)")
          //  completion(error)
        }
       
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error pushing Task to Firebase: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
}
