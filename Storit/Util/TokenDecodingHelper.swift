//
//  TokenDecodingHelper.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation

final class TokenDecodingHelper {
    static let shared = TokenDecodingHelper()
    
    private init() { }
    
    struct TokenDecodedInfo: Decodable {
        let userId: String
        let payload: Int
        let expiration: Int
        
        enum CodingKeys: String, CodingKey {
            case userId = "sub"
            case payload = "iat"
            case expiration = "exp"
        }
    }
    
    func getTokenInfo(token: String) throws -> TokenDecodedInfo {
        // JWT는 3개의 부분으로 나뉨: header.payload.signature
        let segments = token.split(separator: ".")
        
        // 페이로드는 JWT의 두 번째 부분
        guard segments.count == 3 else {
            print("Invalid JWT format")
            throw TokenDecodingError.invalidJWTForamt
        }
        
        let payloadSegment = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        // Base64 인코딩이 제대로 이루어질 수 있도록 패딩을 추가
        let paddedPayload = payloadSegment.padding(toLength: ((payloadSegment.count+3)/4)*4, withPad: "=", startingAt: 0)
        
        // Base64로 디코딩된 데이터
        guard let data = Data(base64Encoded: paddedPayload, options: .ignoreUnknownCharacters) else {
            print("Failed to decode Base64")
            throw TokenDecodingError.decodingError
        }
        
        return try JSONDecoder().decode(TokenDecodedInfo.self, from: data)
    }
}

// MARK: - Error
extension TokenDecodingHelper {
    enum TokenDecodingError: Error {
        case invalidJWTForamt
        case decodingError
    }
}
