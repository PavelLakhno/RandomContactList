//
//  DetailContactViewController.swift
//  RandomContactList
//
//  Created by Pavel Lakhno on 25.01.2023.
//

import UIKit

class DetailContactViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var adressLabel: UILabel!
    
    var result: User!
    var viewModel: DetailContactViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailContactViewModel(user: result)
        setValues()
    }
    
    override func viewWillLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    private func setValues() {
        nameLabel.text = viewModel.name
        ageLabel.text = viewModel.age
        emailLabel.text = viewModel.email
        phoneLabel.text = viewModel.phone
        adressLabel.text = viewModel.adress
        userImageView.image = UIImage(data: viewModel.imageData ?? Data())
    }
}

