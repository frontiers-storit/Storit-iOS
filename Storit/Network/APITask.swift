//
//  APITask.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import Alamofire

enum APITask {
    case requestPlain
    case requestPlainWithoutInterceptor
    case requestParameters(parameters: Parameters)
    case requestBody(body: Encodable)
    case requestBodyWithoutInterceptor(body: Encodable)
    case requestMultiPart(parameters: Parameters, images: [Data], imageKeyName: String)
}
