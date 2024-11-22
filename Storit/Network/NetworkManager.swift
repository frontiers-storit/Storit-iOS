//
//  NetworkManager.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/6/24.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared = NetworkManager()
    
    func request<T: Decodable>(_ endPoint: EndPoint) async -> T? {
        let request = makeDataRequest(endPoint)
        let result = await request.serializingData().result
        Log.network("Request", request.request?.url)
        
        var data = Foundation.Data()
        do {
            data = try result.get()
        } catch {
            Log.error("data fetch error", "")
            return nil
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            Log.network("Response", decodedData)
            return decodedData
        } catch {
            Log.error("data decode error - origin data:", String(data: data, encoding: .utf8) ?? "")
            return nil
        }
        
    }
    
    private func makeDataRequest(_ endPoint: EndPoint) -> DataRequest {
        switch endPoint.task {
        case .requestPlain:
            return AF.request(
                "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                headers: endPoint.headers
            )
        case .requestPlainWithoutInterceptor:
            return AF.request(
                "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                headers: endPoint.headers
            )
        case let .requestParameters(parameters):
            return AF.request(
                "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                parameters: parameters,
                encoding: URLEncoding.default,
                headers: endPoint.headers
            )
        case let .requestBody(body):
            return AF.request(
                "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: endPoint.headers
            )
        case let .requestBodyWithoutInterceptor(body):
            return AF.request(
                "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                parameters: body,
                encoder: JSONParameterEncoder.default,
                headers: endPoint.headers
            )
        case let .requestMultiPart(parameters, images, imageKeyName):
            return AF.upload(
                multipartFormData: { multipartFormData in
                    for (key, value) in parameters {
                        // 정수 배열인 경우 직렬화
                        if let intArray = value as? [Int] {
                            let arrayString = intArray.map { "\($0)" }.joined(separator: ",") // "2,3,4"
                            if let arrayData = arrayString.data(using: .utf8) {
                                multipartFormData.append(arrayData, withName: key)
                            }
                        } else if let data = String(describing: value).data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                    for image in images {
                        multipartFormData.append(image, withName: imageKeyName, fileName: "\(image).jpeg", mimeType: "image/jpeg")
                    }
                }, to: "\(endPoint.baseURL)\(endPoint.path)",
                method: endPoint.method,
                headers: endPoint.headers
            )
        }
    }
}
