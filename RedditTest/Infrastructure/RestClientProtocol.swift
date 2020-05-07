//
//  IRestClient.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 07/05/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol RestClientProtocol {
    func execute<T>(target: Target, parameters: [String : Any]?, completion: @escaping (DataResult<T>) -> Void, processResponse: @escaping (JSON) -> T?)
    func execute<T>(target: Target, parameters: [String : Any]?, completion: @escaping (DataResult<[T]>) -> Void, processResponse: @escaping (JSON) -> [T]?)
    func getTop(from subreddit: String, before: String?, after: String?, limit: Int?, count: Int?, completion: @escaping (DataResult<([Post], Subreddit)>) -> Void)
}

extension RestClientProtocol {
    func execute<T>(target: Target, parameters: [String : Any]? = nil, completion: @escaping (DataResult<T>) -> Void, processResponse: @escaping (JSON) -> T?) {
        return execute(target: target, parameters: parameters, completion: completion, processResponse: processResponse)
    }
    
    func execute<T>(target: Target, parameters: [String : Any]? = nil, completion: @escaping (DataResult<[T]>) -> Void, processResponse: @escaping (JSON) -> [T]?) {
        return execute(target: target, parameters: parameters, completion: completion, processResponse: processResponse)
    }
}
