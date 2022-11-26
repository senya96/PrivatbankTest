//
//  APIManager.swift
//  PrivatbankTest
//
//  Created by Sergiy Nasinnyk on 25.11.2022.
//

import Moya

final class APIManager {
    
    public static func request<T: Decodable, TType: TargetType>(provider: MoyaProvider<TType>, target: TType, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let strResponse = String(decoding: response.data, as: UTF8.self)
                    print("---")
                    print(strResponse)
                    print("---")
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
