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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues(with: result)
    }
    
    override func viewWillLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    private func setValues(with user: User) {
        nameLabel.text = "\(user.name?.first ?? "") \(user.name?.last ?? "")"
        ageLabel.text = "\(user.dob?.age ?? -1) years"
        emailLabel.text = user.email
        phoneLabel.text = user.phone
        adressLabel.text = "\(user.location?.country ?? ""), \(user.location?.city ?? "")"
        
        if let imageURL = user.picture?.large {
            NetworkManager.shared.fetchImage(from: imageURL) { [unowned self] result in
                switch result {
                case .success(let imageData):
                    self.userImageView.image = UIImage(data: imageData)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
}

