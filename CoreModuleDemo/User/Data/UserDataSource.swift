//
//  UserDataSource.swift
//  CoreModuleDemo
//
//  Created by Mina Atef on 21/06/2023.
//

import Foundation
import TFCore

protocol UserDataSourceProtocol {
    func gerUserData(completion: @escaping ([User]?, Error?) -> Void)
}
class UserDataSource: UserDataSourceProtocol {
    
    func gerUserData(completion: @escaping ([User]?, Error?) -> Void) {
//
//        let user = User()
//        user.name = "Name"
//
//        let data = NetworkManager.shared().body(parameters: user)
        
        let url = ServerConstants.baseUrl + ServerConstants.userPath
        
        NetworkManager.shared().request(url: url, method: .get, contentType: .normal, parameters: nil) { userData, error in
            guard let userData = userData else {return}
            let userResponseModel = NetworkManager.shared().decodeData(data: userData, fromModel: [User].self)
            completion(userResponseModel, nil)
            
        }
    }
}
