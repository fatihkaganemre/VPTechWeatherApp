//
//  NetworkService.swift
//  VPTechWeatherApp
//
//  Created by Fatih Kagan Emre on 09/05/2024.
//

import Foundation
import RxSwift

protocol NetworkServiceProtocol {
    func fetch<T: Decodable>(request: NetworkRequest) -> Observable<T>
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession = .shared
    
    func fetch<T: Decodable>(request: NetworkRequest) -> Observable<T> {
        return Observable<T>.create { [weak self] observer in
            guard let urlRequest = request.urlRequest() else {
                observer.onError(NetworkError.wrongRequest)
                return Disposables.create()
            }
            
            let dataTask = self?.session.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    observer.onError(NetworkError.requestFailed(error))
                }
                guard let data  = data else {
                    observer.onError(NetworkError.noData)
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .secondsSince1970
                    let model = try decoder.decode(T.self, from: data)
                    observer.onNext(model)
                } catch {
                    observer.onError(NetworkError.decodingError(error))
                }
            }
            dataTask?.resume()
            
            return Disposables.create {
                dataTask?.cancel()
            }
        }
    }
}
