import UIKit

class ItemTableViewController: UITableViewController {

    var viewModel = ItemTableViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetchData()
    }

    @IBAction func didTapAdd(_ sender: Any) {
        let alert = UIAlertController(title: viewModel.alertTitle, message: viewModel.alertMessage, preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: nil)
        
        alert.addAction(UIAlertAction(title: viewModel.actionTitle, style: .default, handler: { (_) in
            guard let todoTitle = alert.textFields![0].text else { return }
            let newIndex = self.viewModel.todoList.count
            self.viewModel.addToDo(todoTitle)
            self.tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
            self.viewModel.saveData()
        }
        ))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = UIColor.clear
        
        if indexPath.row < viewModel.todoList.count {
            let item = viewModel.todoList[indexPath.row]
            cell.textLabel?.text = item.title
            
            let accessory: UITableViewCellAccessoryType = item.done ? .checkmark : .none
            cell.accessoryType = accessory
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.row < viewModel.todoList.count {
            viewModel.toggleDone(row: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        viewModel.saveData()
    }
    
    // MARK: - functionality for delete rows
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.todoList.count {
            viewModel.deleteItem(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .top)
        }
        viewModel.saveData()
    }
}
