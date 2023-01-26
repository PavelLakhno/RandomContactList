//
//  DetailContactViewController.swift
//  RandomContactList
//
//  Created by user on 25.01.2023.
//

import UIKit

class DetailContactViewController: UIViewController {

    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var firstNameLabel: UILabel!
    @IBOutlet var lastNameLabel: UILabel!
    
    var result: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues(with: result)
    }
    
    override func viewWillLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.bounds.height / 2
    }
    
    private func setValues(with user: User) {
        firstNameLabel.text = result.name?.first
        lastNameLabel.text = result.name?.last
        
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

