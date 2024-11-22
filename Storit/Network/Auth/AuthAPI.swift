//
//  AuthAPI.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import Foundation
import Alamofire

enum AuthAPI {
    case socialLogin(req: SocialLoginRequest)
    case logout
}

extension AuthAPI: EndPoint {
    
    var baseURL: String {
        return "https://storit-api-909260373550.asia-northeast3.run.app"
    }
    
    var path: String {
        switch self {
        case .socialLogin:
            return "/api/v1/auth/social-login"
        case .logout:
            return "/api/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .socialLogin:
            return .post
        case .logout:
            return .post
        }
    }
    
    var task: APITask {
        switch self {
        case let .socialLogin(body):
            return .requestBody(body: body)
        case .logout:
            return .requestPlain
        }
    }
    
    var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .socialLogin:
            return["Content-Type": "application/json"]
        default:
            let token = AuthenticationManager.shared.userToken ?? ""
            
            return["Authorization": "Bearer \(token)",
                   "Content-Type": "application/json"]
        }
    }
}
