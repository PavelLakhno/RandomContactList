//
//  DetailContactViewModel.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 02.02.2023.
//

import Foundation

protocol DetailContactViewModelProtocol {
    
    var name: String { get }
    var age: String { get }
    var email: String { get }
    var phone: String { get }
    var adress: String { get }
    var imageData: Data? { get }

    init(user: User)
}

class DetailContactViewModel: DetailContactViewModelProtocol {
   
    var name: String {
        "\(user.name?.first ?? "") \(user.name?.last ?? "")"
    }
    
    var age: String {
        user.dob?.age?.formatted() ?? ""
    }
    
    var email: String {
        user.email ?? ""
    }
    
    var phone: String {
        user.phone ?? ""
    }
    
    var adress: String {
        "\(user.location?.country ?? ""), \(user.location?.city ?? "")"
    }
    
    var imageData: Data? {
        ImageManager.shared.fetchImageData(from: user.picture?.large)
    }

    private let user: User
    
    required init(user: User) {
        self.user = user
    }
}
