//
//  ContactCell.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 03.02.2023.
//

import UIKit

class ContactCell: UITableViewCell {
    var viewModel: ContactCellViewModelProtocol! {
        didSet {
            var content = defaultContentConfiguration()
            content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
            content.imageProperties.cornerRadius = 50
            
            content.text = viewModel.userName
            content.secondaryText = viewModel.userEmail
            guard let imageData = viewModel.imageData else { return }
            content.image = UIImage(data: imageData)
            contentConfiguration = content
        }
    }
}
