//
//  Api.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 4/4/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

final class RestClient: RestClientProtocol {
    // MARK: - Private Functions
    private func start<T>(target: Target, parameters: [String : Any]? = nil, headers: [String : String]? = nil, completion: @escaping (DataResult<T>) -> Void, processResponse: @escaping (Data) -> Any?) {
        var request = URLRequest(url: target.url)
        request.httpMethod = target.method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        if let targetSpecificHeaders = target.commonHeaders {
            targetSpecificHeaders.forEach { headerField in
                request.setValue(headerField.value, forHTTPHeaderField: headerField.key)
            }
        }
        if let headers = headers {
            headers.forEach { headerField in
                request.setValue(headerField.value, forHTTPHeaderField: headerField.key)
            }
        }
        request.httpBody = parameters?.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, responseError in
            guard let responseError = responseError else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String : Any]
                    _ = try target.searchError(json)
                    let parsedObject = processResponse(data!) as! T
                    completion( DataResult { return parsedObject } )
                } catch let error as NSError {
                    completion( DataResult { throw error })
                }
                return
            }
            completion( DataResult { throw responseError })
        }
        task.resume()
    }

    // MARK: - Internal Functions
    internal func execute<T>(target: Target, parameters: [String : Any]? = nil, completion: @escaping (DataResult<T>) -> Void, processResponse: @escaping (Data) -> T?) {
        self.start(target: target, parameters: parameters, headers: nil, completion: completion, processResponse: processResponse)
    }
    
    internal func execute<T>(target: Target, parameters: [String : Any]? = nil, completion: @escaping (DataResult<[T]>) -> Void, processResponse: @escaping (Data) -> [T]?) {
        self.start(target: target, parameters: parameters, headers: nil, completion: completion, processResponse: processResponse)
    }
}
