//
//  NetworkingFramework.swift
//  NetworkingFramework
//
//  Created by ZeroGravity on 1/13/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

public typealias QueryParameters = [URLQueryItem]
public typealias RequestHeaders = [String: String]
public typealias NetworkResponseHandler<Data: Decodable> = (Data?, HTTPURLResponse?, Error?)->Void

open class NetworkingFramework {
    private let urlReq: URLRequest!
    
    public enum HTTPMethod: String {
        case options = "OPTIONS"
        case get     = "GET"
        case head    = "HEAD"
        case post    = "POST"
        case put     = "PUT"
        case patch   = "PATCH"
        case delete  = "DELETE"
        case trace   = "TRACE"
        case connect = "CONNECT"
    }
    
    enum NetworkError: Error {
        case JSONDecodeError
        
        var debugDescription: String {
            switch self {
            case .JSONDecodeError:
                return "JSON decoding error!"
            }
        }
    }
    
    init(urlReq: URLRequest) {
        self.urlReq = urlReq
    }
    
    @discardableResult
    public static func request(url: URL, method: HTTPMethod, requestHeaders: RequestHeaders = ["Content-Type": "application/json"], urlQueries: QueryParameters? = nil, bodyParameters: [String: Any]? = nil) -> NetworkingFramework {
        
        let urlReq = getRequestObj(url: url, method: method, requestHeaders: requestHeaders, urlQueries: urlQueries, bodyParameters: bodyParameters)
        
        print(urlReq.url)
        
        return NetworkingFramework(urlReq: urlReq)
    }
    
    private static func getRequestObj(url: URL, method: HTTPMethod, requestHeaders: RequestHeaders, urlQueries: QueryParameters?, bodyParameters: [String: Any]?) -> URLRequest {
        
        var urlRequest = URLRequest(url: url)
        
        if let urlQueries = urlQueries,
           var components = URLComponents(string: url.absoluteString) {
            components.queryItems = urlQueries
            urlRequest = URLRequest(url: components.url ?? url)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = requestHeaders
        urlRequest.httpBody = encoadingBodyParameters(bodyParameters)
        
        return urlRequest
    }
    
    private static func encoadingBodyParameters(_ parameters: [String: Any]?) -> Data? {
        guard let parameters = parameters,
              let bodyData = try? JSONSerialization.data(withJSONObject: parameters) else { return nil }
        
        return bodyData
    }
}

extension NetworkingFramework {
    @discardableResult
    open func response<Data: Decodable>(dataType: Data.Type, complection: NetworkResponseHandler<Data>?) -> URLSessionDataTask {
        let sessionTask = URLSession.shared.dataTask(with: urlReq) { (data, urlResponse, error) in
            let urlResponse = urlResponse as? HTTPURLResponse
            
            DispatchQueue.main.async {
                guard let data = data else {
                    complection?(nil, urlResponse, error)
                    return
                }
                
                guard let json = try? JSONDecoder().decode(dataType, from: data) else {
                    complection?(nil, urlResponse, error ?? NetworkError.JSONDecodeError)
                    return
                }
                
                complection?(json, urlResponse, error)
            }
        }
        
        sessionTask.resume()
        return sessionTask
    }
}
