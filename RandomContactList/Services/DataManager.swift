//
//  DataManager.swift
//  RandomContactList
//
//  Created by user on 28.01.2023.
//

import Foundation
import CoreData

class DataManager {
    
    static let shared = DataManager()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RandomContactList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func fetchData(completion: ([User]) -> Void) {
        let fetchRequest = UserStorage.fetchRequest()
        
        do {
            let userStorage = try viewContext.fetch(fetchRequest)
            var users: [User] = []
            
            for data in userStorage as [NSManagedObject] {
                let gender = data.value(forKey: "gender") as? String ?? ""
                let firstName = data.value(forKey: "firstName") as? String ?? ""
                let lastName = data.value(forKey: "lastName") as? String ?? ""
                let name = Name.init(first: firstName, last: lastName)
                let email = data.value(forKey: "email") as? String ?? ""
                let pictureLittle = data.value(forKey: "pictureLittle") as? String ?? ""
                let pictureLarge = data.value(forKey: "pictureLarge") as? String ?? ""
                let picture = Picture(large: pictureLarge, thumbnail: pictureLittle)
                let phone = data.value(forKey: "phone") as? String ?? ""
                //let age = data.value(forKey: "age") as? Int ?? -1
                let streetName = data.value(forKey: "streetName") as? String ?? ""
                let streetNumber = data.value(forKey: "streetNumber") as? Int ?? -1
                let street = Street.init(number: streetNumber, name: streetName)
                let city = data.value(forKey: "city") as? String ?? ""
                let country = data.value(forKey: "country") as? String ?? ""
                let state = data.value(forKey: "state") as? String ?? ""
                let location = Location.init(street: street, city: city, state: state, country: country)
                let object = User.init(gender: gender, name: name, location: location, email: email, phone: phone, cell: "", picture: picture)
                users.append(object)
            }

            completion(users)
        } catch let error {
            print(error.localizedDescription)
        }
    }
                       
    
    //func save(_ newUser: User, completion: (UserStorage) -> Void) {
    func save(_ newUser: User) {
        let user = UserStorage(context: viewContext)
        user.title = newUser.name?.title
        user.firstName = newUser.name?.first
        user.lastName = newUser.name?.last
        user.email = newUser.email
        user.country = newUser.location?.country
        user.city = newUser.location?.city
        user.gender = newUser.gender
        user.phone = newUser.phone
        user.streetName = newUser.location?.street?.name
        //user.streetNumber = newUser.location?.street?.number
        user.pictureLittle = newUser.picture?.thumbnail
        user.pictureLarge = newUser.picture?.large
        
        //completion(user)
        saveContext()
    }

    
    // MARK: - Core Data Saving support
    func saveContext () {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
