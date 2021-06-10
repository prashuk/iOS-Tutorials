//
//  EmployeeTableViewController.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.
//

import UIKit

class EmployeeTableViewController: UITableViewController {

    private var employeeViewModel = EmployeeViewModel()
    private var employees = [EmployeeData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.employeeViewModel.bindEmployeeViewModelToController = {
            self.employees = self.employeeViewModel.empData.data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

// MARK: - Table view data source
extension EmployeeTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.employees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = self.employees[indexPath.row]
        cell.imageView?.imageFromServerURL(url: item.picture, PlaceHolderImage: UIImage(systemName: "person.circle")!)
        cell.textLabel?.text = item.title.rawValue.capitalizingFirstLetter() + ". " + item.firstName + " " + item.lastName
        cell.detailTextLabel?.text = item.email
        return cell
    }
}

// MARK: - Table view data delegate
extension EmployeeTableViewController {
    
}

// MARK: - Image View
extension UIImageView {
    public func imageFromServerURL(url: String, PlaceHolderImage: UIImage) {
        if self.image == nil {
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
        }.resume()
    }
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
