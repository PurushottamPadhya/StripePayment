//
//  StripeClient.swift
//  WTV_GO
//
//  Created by NITV on 5/3/18.
//  Copyright © 2018 nitv. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

enum Result {
    case success((DataResponse<Any>))
    case failure(Error)
}

final class StripeClient {

    static let shared = StripeClient()
    
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: StripeConstants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func verifyToken(with token: STPToken, amount: Double, completion: @escaping (Result) -> Void) {

        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": (amount * 100),
            "currency": StripeConstants.defaultCurrency,
            "mechanism": "Stripe"
        ]

        Alamofire.request(baseURL, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
            .validate(statusCode: 200..<500)
            .responseJSON{ response in
                switch response.result {
                case .success:
                    completion(Result.success(response))
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
}

