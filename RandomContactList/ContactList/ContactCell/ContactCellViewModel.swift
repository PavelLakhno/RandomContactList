//
//  ContactCellViewModel.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 03.02.2023.
//

import Foundation

protocol ContactCellViewModelProtocol {
    var userName: String { get }
    var userEmail: String { get }
    var imageData: Data? { get }
    init(user: User)
}

class ContactCellViewModel: ContactCellViewModelProtocol {
    var userName: String {
        "\(user.name?.first ?? "") \(user.name?.last ?? "")"
    }
    
    var userEmail: String {
        user.email ?? ""
    }
    
    var imageData: Data? {
        ImageManager.shared.fetchImageData(from: user.picture?.thumbnail)
    }
    
    private let user: User
    
    required init(user: User) {
        self.user = user
    }
}
