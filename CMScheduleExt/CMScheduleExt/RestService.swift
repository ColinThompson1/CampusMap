//
//  RestService.swift
//  CMScheduleExt
//
//  Created by Colin Thompson on 2018-12-11.
//  Copyright © 2018 CampusMAppTeam. All rights reserved.
//

import Foundation
import PromiseKit

class RestService {
    
    static let shared = RestService()
    private let urlSession: URLSession
    
    //todo: move these to environment and ocr uri behind the reverse proxy
    private let baseURL = "http://ec2-35-183-144-123.ca-central-1.compute.amazonaws.com"
    private let baseURLOCR = "https://s6j0mqklib.execute-api.ca-central-1.amazonaws.com/dev"
    
    private init() {
        self.urlSession = URLSession(configuration: .default)
    }
    
    func get<T>(path: String, params: Dictionary<String, String>, resultType: T.Type) -> Promise<T> where T : Decodable {
        var url: URL
        do {
            url = try generateURL(path: path, params: params, baseURL: baseURL)
        } catch let e {
            return Promise(error: e)
        }
        
        return firstly {
            urlSession.dataTask(.promise, with: url)
            }.compactMap {
                try? JSONDecoder().decode(resultType, from: $0.data)
            }
    }
    
    func postPNG<T>(path: String, params: Dictionary<String, String>, image: UIImage, responseType: T.Type) -> Promise<T> where T : Decodable {
        var url: URL
        do {
            url = try generateURL(path: path, params: params, baseURL: baseURLOCR)
        } catch let e {
            return Promise(error: e)
        }
        
        guard let imgData: Data = image.pngData() else {
            return Promise(error: RestError.InternalRestError("Could not convert image for request"))
        }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("image/png", forHTTPHeaderField: "Accept")
        req.addValue("image/png", forHTTPHeaderField: "Content-Type")
        
        return firstly {
            urlSession.uploadTask(.promise, with: req, from: imgData)
            }.compactMap {
                try? JSONDecoder().decode(responseType, from: $0.data)
        }
    }
    
    private func generateURL(path: String, params: Dictionary<String, String>, baseURL: String) throws -> URL  {
        let queryParams: [URLQueryItem] = params.map { (k, v) -> URLQueryItem in
            return URLQueryItem(name: k, value: v)
        }
        
        var urlComp = URLComponents(string: baseURL + path)
        urlComp?.queryItems = queryParams
        
        guard let url = urlComp?.url else {
            throw RestError.InternalRestError("Failed to generate url")
        }
        return url
    }
    
}

enum RestError: Error {
    case InternalRestError(String)
}
