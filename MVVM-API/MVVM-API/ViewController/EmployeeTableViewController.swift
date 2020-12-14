//
//  EmployeeTableViewController.swift
//  MVVM-API
//
//  Created by Prashuk Ajmera on 12/13/20.
//

import UIKit

class EmployeeTableViewController: UITableViewController {

    private var employeeViewModel = EmployeeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("hi")
        return self.employeeViewModel.employee.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = employeeViewModel.employee[indexPath.row]
        DispatchQueue.main.async {
            cell.textLabel?.text = item.employeeName
            cell.detailTextLabel?.text = item.employeeAge
        }
        return cell
    }
}
