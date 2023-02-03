//
//  ContactListViewController.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 25.01.2023.
//

import UIKit

class ContactListViewController: UITableViewController {

    private var viewModel: ContactListViewModelProtocol! {
        didSet {
            viewModel.fetchUsersFromData { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ContactListViewModel()
        tableView.rowHeight = 80
        setupRefreshControl()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(downloadData)
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailContactViewController {
            detailVC.viewModel = sender as? DetailContactViewModelProtocol
        }
    }
   
}

// MARK: - UITAbleViewDataSource
extension ContactListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        guard let cell = cell as? ContactCell else { return UITableViewCell() }
        cell.viewModel = viewModel.getContactCellViewModel(at: indexPath)
        print(cell.viewModel.userName)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController {
    /*
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let user = contacts[indexPath.row]
            DataManager.shared.delete(user: user)
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentUser = viewModel.getDetailContactViewModel(at: indexPath) //contacts[indexPath.row]
        performSegue(withIdentifier: Segues.showContact.rawValue, sender: currentUser)
    }
}

// MARK: - Private Methods
extension ContactListViewController {

    @objc private func downloadData() {
        
        viewModel.fetchUsersFromApi { [weak self] in
            if self?.refreshControl != nil {
                self?.refreshControl?.endRefreshing()
            }
            self?.tableView.reloadData()
        }
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
    
}
