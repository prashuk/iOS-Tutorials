//
//  ViewController.swift
//  Searching
//
//  Created by Prashuk Ajmera on 1/4/21.
//

import UIKit

class ViewController: UIViewController {
    
    let viewModel = ViewModel()

    var tableView: UITableView!
    var searchController: UISearchController!
    
    var data = [EmployeeData]()
    var dataFilter: [EmployeeData] = []
    
    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFilter: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel.binding = {
            self.data = self.viewModel.empData.data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        self.title = "Search"
        
        tableView = UITableView.create(forCell: "myCell")
        tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Seach Name"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        self.view.addSubview(tableView)
    }
}

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFilter {
            return self.dataFilter.count
        } else {
            return self.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        if isFilter {
            let item = self.dataFilter[indexPath.row]
            cell.textLabel?.text = item.firstName + " " + item.lastName
            cell.detailTextLabel?.text = item.email
        } else {
            let item = self.data[indexPath.row]
            cell.textLabel?.text = item.firstName + " " + item.lastName
            cell.detailTextLabel?.text = item.email
        }
        return cell
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearch(searchText: searchBar.text!)
    }
    
    func filterContentForSearch(searchText: String) {
        dataFilter = data.filter({ (data) -> Bool in
            return data.firstName.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
}

extension UITableView {
    static func create(forCell: String) -> UITableView {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: forCell)
        return tableView
    }
}
