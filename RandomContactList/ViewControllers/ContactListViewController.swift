//
//  ContactListViewController.swift
//  RandomContactList
//
//  Created by user on 25.01.2023.
//

import UIKit

class ContactListViewController: UITableViewController {

    private var contacts: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 60
        applyNetworking()
        setupRefreshControl()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(downloadData)
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailContactViewController {
            detailVC.result = sender as? User
        }
    }
    
    private func applyNetworking() {
         
        DataManager.shared.fetchData { [unowned self] response in
            
            if response.count == 0 {
                print("Data from Api")
                self.downloadData()
            } else {
                print("Data from Coredata.")
                self.contacts = response
                self.tableView.reloadData()
            }
        }
    }
     
}

// MARK: - UITAbleViewDataSource
extension ContactListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contacts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Contact", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        content.imageProperties.cornerRadius = 50
        
        let contact = contacts[indexPath.row]
        content.text = contact.name?.first
        content.secondaryText = contact.name?.last
        
        
        if let imageURL = contact.picture?.thumbnail {
            NetworkManager.shared.fetchImage(from: imageURL) { result in
                switch result {
                case .success(let imageData):
                    content.image = UIImage(data: imageData)
                    cell.contentConfiguration = content
                case .failure(let error):
                    print(error)
                }
            }
        }

        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ContactListViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            contacts.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentUser = contacts[indexPath.row]
        performSegue(withIdentifier: Segues.showContact.rawValue, sender: currentUser)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private Methods
extension ContactListViewController {

    @objc private func downloadData() {
        
        NetworkManager.shared.fetchUsers(from: URLConstants.randomUserAPI.rawValue) { [weak self] result in
            switch result {
            case .success(let users):
                for user in users.results {
                    DataManager.shared.save(user)
                    self?.contacts.insert(contentsOf: users.results, at: 0)
                    self?.tableView.reloadData()
                }
                if self?.refreshControl != nil {
                    self?.refreshControl?.endRefreshing()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(downloadData), for: .valueChanged)
    }
    
}
