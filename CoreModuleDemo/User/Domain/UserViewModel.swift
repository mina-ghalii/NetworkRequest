//
//  UserViewModel.swift
//  CoreModuleDemo
//
//  Created by Mina Atef on 21/06/2023.
//

import Foundation

protocol UserViewModelProtocol {
    func getUserData()
    var users: Observable<[User]> {get set}
}

class UserViewModel: UserViewModelProtocol {
    
    var dataSource: UserDataSourceProtocol?
    var users: Observable<[User]> = Observable([])
    
    init(dataSource: UserDataSourceProtocol = UserDataSource()) {
        self.dataSource = dataSource
    }
    
    func getUserData() {
        dataSource?.gerUserData() { users, error in
            
            if error == nil {
                self.users.value = users ?? []
            } else {
                //handle error here
            }
            
        }
    }
}
