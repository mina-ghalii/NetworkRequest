//
//  NetworkManager.swift
//  TFCore
//
//  Created by Mina Atef on 21/06/2023.
//

import Foundation
import UIKit

public class NetworkManager {
    
    private static var sharedInstance: NetworkManager? = NetworkManager()
    private var network: NetworkRequestProtocol?
    
    private init() {
        network = URLSessionNetworkRequest()
    }
    
    public static func shared() -> NetworkManager {
        if let sharedInstance = self.sharedInstance {
            return sharedInstance
        } else {
            let sharedInstance = NetworkManager()
            self.sharedInstance = sharedInstance
            return sharedInstance
        }
    }
    
    static func dealocate() {
        sharedInstance = nil
    }
    
    public func setup(network: NetworkRequestProtocol, certificates: [Data]) {
        self.network = network
        self.network?.certificates = certificates
    }
    
    public func request(url: String, method: HTTPMethod, contentType: ContentType, parameters: Data?, completion: @escaping (Data?, Error?) -> Void) {
        guard let url = URL(string: url) else {return}
        guard let network = network else {return}
        network.request(url: url, method: method, contentType: contentType, parameters: parameters, completion: completion)
    }
    
    public func body<T: Codable>(parameters: T) -> Data? {
        let encoder = JSONEncoder()
        do {
            let encodedData = try encoder.encode(parameters)
            return encodedData
        } catch {
            return nil
        }
    }
    
    public func decodeData<T: Codable>(data: Data, fromModel: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let data = try decoder.decode(T.self, from: data )
            return data
        } catch let error {
            return nil
        }
    }

}

public protocol NetworkRequestProtocol {
    func request(url: URL, method: HTTPMethod, contentType: ContentType, parameters: Data?, completion: @escaping (Data?, Error?) -> Void)
    var certificates: [Data] {get set}
}

public enum ContentType {
    case normal
    case multipart
}

public enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

