//
//  Services.swift
//  Searching
//
//  Created by Prashuk Ajmera on 1/5/21.
//

import Foundation

class Services {
    func getData(completion: @escaping (Employee) -> ()) {
        let urlString = "https://dummyapi.io/data/api/user"
        let url = URL(string: urlString)!
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "app-id": API_KEY
        ]
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let httpresponse = response as? HTTPURLResponse, (200...299).contains(httpresponse.statusCode) else {
                print(String(describing: response))
                return
            }
            
            if let data = data, let empData = try? JSONDecoder().decode(Employee.self, from: data) {
                completion(empData)
            }
        }.resume()
    }
}
