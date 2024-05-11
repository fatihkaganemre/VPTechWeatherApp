//
//  NetworkRequest.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation

struct NetworkRequest {
    let path: String
    let method: HTTPMethod
    let parameters: [URLQueryItem]?
    
    init(
        path: String,
        method: HTTPMethod,
        parameters: [URLQueryItem]? = nil
    ) {
        self.path = path
        self.method = method
        self.parameters = parameters
    }
    
    enum HTTPMethod: String {
        case POST
        case GET
        case PUT
        case DELETE
        case PATCH
    }
    
    func urlRequest(apiKey: String?) -> URLRequest? {
        guard var urlComponent = URLComponents(string: path) else { return nil }
        urlComponent.queryItems = parameters
        urlComponent.queryItems?.append(.init(name: "appid", value: apiKey))
        guard let url = urlComponent.url  else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
