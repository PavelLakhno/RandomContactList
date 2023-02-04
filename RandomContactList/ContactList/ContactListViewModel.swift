//
//  ContactListViewModel.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 02.02.2023.
//

import Foundation

protocol ContactListViewModelProtocol {
    func fetchUsersFromApi(completion: @escaping() -> Void)
    func fetchUsersFromData(completion: @escaping() -> Void)
    func numberOfRows() -> Int
    func removeContactCellViewModel(at indexPath: IndexPath)
    func getContactCellViewModel(at indexPath: IndexPath) -> ContactCellViewModelProtocol
    func getDetailContactViewModel(at indexPath: IndexPath) -> DetailContactViewModelProtocol
}

class ContactListViewModel: ContactListViewModelProtocol {

    private var users: [User] = []
    
    func fetchUsersFromApi(completion: @escaping () -> Void) {
        NetworkManager.shared.fetchUsers(from: URLConstants.randomUserAPI.rawValue) {[unowned self] result in
            switch result {
            case .success(let users):
                for user in users.results {
                    DataManager.shared.save(user)
                    fetchUsersFromData() {}
                }
            case .failure(let error):
                print(error)
            }
            completion()
        }
    }
    
    func fetchUsersFromData(completion: @escaping () -> Void) {
        DataManager.shared.fetchData { [unowned self] response in
            self.users = response.reversed()
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        users.count
    }
    
    func removeContactCellViewModel(at indexPath: IndexPath)  {
        DataManager.shared.delete(user: users[indexPath.row])
        fetchUsersFromData() {}
    }

    func getContactCellViewModel(at indexPath: IndexPath) -> ContactCellViewModelProtocol {
        ContactCellViewModel(user: users[indexPath.row])
    }

    func getDetailContactViewModel(at indexPath: IndexPath) -> DetailContactViewModelProtocol {
        DetailContactViewModel(user: users[indexPath.row])
    }    
}
