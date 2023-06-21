//
//  NetworkRequest.swift
//  TFCore
//
//  Created by Mina Atef on 21/06/2023.
//

import Foundation

public class URLSessionNetworkRequest: NSObject, URLSessionDelegate, NetworkRequestProtocol {
    

    public var certificates: [Data] = []
    private var task: URLSessionDataTask!
    private var session: URLSession!

    public override init() {
        super.init()
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 120
        config.timeoutIntervalForResource = 120
        session = URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }
    
    public func request(url: URL, method: HTTPMethod, contentType: ContentType, parameters: Data?, completion: @escaping (Data?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        switch contentType {
        case .normal:
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = parameters
            
        case .multipart:
            break
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        
        task.resume()
    }

    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {

        let localCertificateData = Data()
        if let trust = challenge.protectionSpace.serverTrust, SecTrustGetCertificateCount(trust) > 0 {
            for i in 0..<SecTrustGetCertificateCount(trust) {
                
                if let certificate = SecTrustGetCertificateAtIndex(trust, i) {
                    
                    // Set SSL Policies for domain name check
                    let policies = NSMutableArray()
                    policies.add(SecPolicyCreateSSL(true, nil))
                    
                    // Evaluate server certificate
                    let remoteCertificateData: NSData = SecCertificateCopyData(certificate)
                    
                    // Evaluate remote & local certificates
                    var optionalTrust: SecTrust?
                    let localCertificate = SecCertificateCreateWithData(nil, localCertificateData as CFData)
                    
                    let isTrusted = SecTrustCreateWithCertificates(
                        localCertificate as AnyObject,
                        policies,
                        &optionalTrust)
                    
                    let isValid = remoteCertificateData.isEqual(to: localCertificateData as Data)
                    
                    guard isTrusted == errSecSuccess, isValid  else {
                        if i < (SecTrustGetCertificateCount(trust)-1) {
                            continue
                        }

                        completionHandler(.cancelAuthenticationChallenge, nil)
                        return
                    }
                    // "SSL pinning Completed Authentication Challenge"
                    completionHandler(.useCredential, URLCredential(trust: trust))
                    break
                }
            }
        }
    }
    
}
