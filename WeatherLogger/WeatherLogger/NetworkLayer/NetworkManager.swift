//
//  NetworkManager.swift
//  WeatherLogger
//
//  Created by Akanksha garg on 16/07/20.
//  Copyright © 2020 Akanksha garg. All rights reserved.
//

import Foundation

// Enum to return specific error message
enum JsonError: Error, CustomStringConvertible {
    case serviceError
    case noData
    
    var description: String {
        switch self {
        case .serviceError:
            return "There was some problem in fetching data"
        case .noData:
            return "No Data Found"
        }
        
    }
}

/// This class is used for making network calls
class NetworkManager {
    
    // MARK: -
    let baseURL: URL
    
    // MARK: - Properties
    private static var sharedNetworkManager: NetworkManager = {
        let networkManager = NetworkManager(baseURL: URL(string: API.kBaseURL)!)
        return networkManager
    }()
    
    // Initialization
    private init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    // MARK: - Accessors
    class func shared() -> NetworkManager {
        return sharedNetworkManager
    }
    
    /// - parameter apiURL: Api url
    /// - parameter onCompletion: Returns flag for api success, response header and response data
    func callGetAPI<Model: Decodable>(apiURL: String, requestData: [String: String]?, onCompletion: @escaping(Error?, Model?) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        //Adding Query Params to URL
        let urlComponents = NSURLComponents(string: API.kBaseURL+apiURL)!
        urlComponents.queryItems = [URLQueryItem]()
        if let paramData = requestData {
            for (key, value) in paramData {
                let queryItem = URLQueryItem(name: key, value: value)
                urlComponents.queryItems?.append(queryItem)
            }
        }
        
        let task = session.dataTask(with: urlComponents.url!) { data, _, error in
            
            // ensure there is no error for this HTTP response
            guard error == nil else {
                print("error: \(error!)")
                onCompletion(JsonError.serviceError, nil)
                return
            }
            // ensure there is data returned from this HTTP response
            guard let content = data else {
                onCompletion(JsonError.noData, nil)
                return
            }
            
            // serialise the data / NSData object into Dictionary [String : Any]
            let utf8Data = String(decoding: content, as: UTF8.self).data(using: .utf8)
            print(try? JSONSerialization.jsonObject(with: content, options: []) as? [String:Any] )
            
            do {
                let modelObject = try JSONDecoder().decode(Model.self, from: utf8Data!)
                onCompletion(nil, modelObject)
            } catch {
                onCompletion(error, nil)
            }
        }
        task.resume()
        
    }
}
