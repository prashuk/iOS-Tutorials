//
//  APIService.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.
//
/*
 The introduction of Codable in Swift 4, making API calls is much easier.
 Previously most people used pods like Alamofire and SwiftyJson.
 
 Let's go through some building blocks that are often used to make an API call.
 Completion handlers
 URLSession
 DispatchQueue
 Retain cycles
 
 - Completion handlers:
 You use a completion handler in a function when you know that function will take a while to complete. You don't know how long, and you don't want to pause your life waiting for it to finish.
 This is what happens with API calls. You send a URL request to a server, asking it for some data. You hope the server returns the data quickly, but you don't know how long it will take. Instead of making your user wait patiently for the server to give you the data, you use a completion handler. This means you can tell your app to go off and do other things, such as loading the rest of the page.
 
 func fetchFilms(completionHandler: @escaping ([Film]) -> Void) {
 // Setup the variable lotsOfFilms
 var lotsOfFilms: [Film]
 
 // Call the API with some code
 
 // Using data from the API, assign a value to lotsOfFilms
 
 // Give the completion handler the variable, lotsOfFilms
 completionHandler(lotsOfFilms)
 }
 You don't need to reference completionHandler when you call the function. The only time you reference completionHandler is inside the function declaration.
 The completion handler will give us back some data to use.
 
 - Call this service as
 fetchFilms() { (films) in
 // Do something with the data the completion handler returns
 print(films)
 }
 
 - URLSession:
 URLSession is like the manager of a team. The manager doesn't do anything on her own. Her job is to share the work with the people in her team, and they'll get the job done. Her team are dataTasks. Every time you need some data, write to the boss and use URLSession.shared.dataTask
 let url = URL(string: "https://www.swapi.co/api/films")
 let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
 // your code here
 })
 task.resume()
 
 - error
 if let error = error {
     print("Error with fetching films: \(error)")
     return
 }
 
 - response
 guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
     print("Error with the response, unexpected status code: \(String(describing: response))")
     return
 }
 
 - data
 if let data = data, let empData = try? JSONDecoder().decode(Employee.self, from: data) {
     completionHandler(empData)
 }
 
 - Retain cycles
 Retain cycles are important to understand for memory management. Basically you want your app to clean up bits of memory that it doesn't need anymore. I assume this makes the app more performant.
 To get around this, people often use weak. When one side of the code is weak, you don't have a retain cycle and your app will be able to release the memory.
 For our purpose, a common pattern is to use [weak self] when calling the API. This ensures that once the completion handler returns some code, the app can release the memory.
 apiToGetEmployee { [weak self] (empData) in
     // Code here
 }
 
 - DispatchQueue:
 Xcode uses different threads to execute code in parallel. The advantage of multiple threads means you aren't stuck waiting on one thing to finish before you can move on to the next.
 These threads seem to be also called dispatch queues. API calls are handled on one queue, typically a queue in the background. Once you have the data from your API call, most likely you'll want to show that data to the user. That means you'll want to refresh your table view.
 Table views are part of the UI, and all UI manipulations should be done in the main dispatch queue. This means somewhere in your view controller file, usually as part of the viewDidLoad function, you should have a bit of code that tells your table view to refresh.
 apiToGetEmployee { [weak self] (empData) in
     for item in empData.data {
         self?.employee.append(item)
     }
     
     // Dispatch.main.async {}
 }
 
 - viewDidLoad vs viewDidAppear
 Finally you need to decide where to call your apiToGetEmployee function. It will be inside a view controller that will use the data from the API. There are two obvious places you could make this API call. One is inside viewDidLoad and the other is inside viewDidAppear.
 These are two different states for your app. My understanding is viewDidLoad is called the first time you load up that view in the foreground. viewDidAppear is called every time you come back to that view, for example when you press the back button to come back to the view.
 If you expect your data to change in between the times that the user will navigate to and from that view, then you may want to put your API call in viewDidAppear. However I think for almost all apps, viewDidLoad is sufficient. Apple recommends viewDidAppear for all API calls, but that seems like overkill. I imagine it would make your app less performant as it's making many more API calls that it needs to.
 */

import Foundation

class APIService: NSObject {
    
    func apiToGetEmployee(completionHandler: @escaping (Employee) -> ()) {
        let url = URL(string: "http://dummy.restapiexample.com/api/v1/employees")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print("Error with fetching films: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Error with the response, unexpected status code: \(String(describing: response))")
                return
            }
            
            if let data = data, let empData = try? JSONDecoder().decode(Employee.self, from: data) {
                completionHandler(empData)
            }
        })
        
        task.resume()
    }
}
