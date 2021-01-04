//
//  ViewController.swift
//  Searching
//
//  Created by Prashuk Ajmera on 1/4/21.
//

import UIKit

class ViewController: UIViewController {

    var tableView: UITableView!
    var searchController: UISearchController!
    var data: [String] = ["Prashuk", "Ajmera", "Shraddha", "Singh"]
    var dataFilter: [String] = []
    
    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFilter: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")
        if isFilter {
            cell?.textLabel?.text = self.dataFilter[indexPath.row]
        } else {
            cell?.textLabel?.text = self.data[indexPath.row]
        }
        return cell!
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearch(searchText: searchBar.text!)
    }
    
    func filterContentForSearch(searchText: String) {
        dataFilter = data.filter({ (data) -> Bool in
            return data.lowercased().contains(searchText.lowercased())
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
