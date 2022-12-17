//
//  Toolbox.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

open class Toolbox {
    
    // MARK: - echo api
    
    public enum Result<T, E> {
        case success(T), failure(E)
    }
    
    open func echo<T: Decodable, E: Decodable>(_ t: T.Type, _ e: E.Type, json: String) async throws -> Result<T, E> {
        guard json.isValidJSON, let data = json.data(using: .utf8) else {
            throw EchoToolboxError.badRequest("invalid json string.")
        }
        return try await echo(t.self, e.self, json: data)
    }
    
    open func echo<T: Decodable, E: Decodable>(_ t: T.Type, _ e: E.Type, scene: String, case: String?) async throws -> Result<T, E> {
        let data = try loadData(using: scene, case: `case`)
        return try await echo(t.self, e.self, json: data)
    }
    
    open func echo<T: Decodable, E: Decodable>(_ t: T.Type, _ e: E.Type, json: Data) async throws -> Result<T, E> {
        let req = makeRequest(url: endpoint, data: json)
        let (data, res) = try await session.data(for: req)
        guard let res = res as? HTTPURLResponse, (200..<300).contains(res.statusCode) else {
            return .failure(try decoder.decode(e.self, from: data))
        }
        return .success(try decoder.decode(t.self, from: data))
    }
    
    open func echo<T: Decodable>(_ t: T.Type, json: String) async throws -> T {
        guard json.isValidJSON, let data = json.data(using: .utf8) else {
            throw EchoToolboxError.badRequest("invalid json string.")
        }
        return try await echo(t.self, json: data)
    }
    
    open func echo<T: Decodable>(_ t: T.Type, scene: String, case: String?) async throws -> T {
        let data = try loadData(using: scene, case: `case`)
        return try await echo(t.self, json: data)
    }
    
    open func echo<T: Decodable>(_ t: T.Type, json: Data) async throws -> T {
        let req = makeRequest(url: endpoint, data: json)
        let (data, res) = try await session.data(for: req)
        guard let res = res as? HTTPURLResponse, (200..<300).contains(res.statusCode) else {
            throw EchoToolboxError.serviceResponse(data)
        }
        return try decoder.decode(t.self, from: data)
    }
    
    open func makeRequest(url: URL, data: Data) -> URLRequest {
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "content-type")
        req.httpBody = data
        return req
    }
    
    // MARK: - Scene Loader (request data from json file inside main bundle)
    
    open func preview<T: Decodable>(_ t: T.Type, scene: String, case: String? = nil) -> T {
        do {
            return try decode(t.self, scene: scene, case: `case`)
        } catch {
            fatalError("\(error)")
        }
    }
    
    open func decode<T: Decodable>(_ t: T.Type, scene: String, case: String? = nil) throws -> T {
        try loadData(using: scene, case: `case`).decode(t.self, decoder: decoder)
    }
    
    open func loadData(using scene: String, case: String? = nil) throws -> Data {
        var json = try Bundle.main.data(named: scene).anyJson()
        if let `case` = `case` {
            guard let d = json as? [String: Any], let c = d[`case`], JSONSerialization.isValidJSONObject(c) else {
                throw EchoToolboxError.badRequest("unexpected case: \(`case`) in scene: \(scene)")
            }
            json = c
        }
        return try JSONSerialization.data(withJSONObject: json)
    }
    
    // MARK: - Configurations
    
    public class var defaultEndpoint: URL {
        URL(string: "https://echo-api-sigma.vercel.app/api/echo")!
    }
    
    public class var defaultSession: URLSession {
        URLSession.shared
    }
    
    public class var defaultDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let iso8601ms = Formatter.iso8601ms
        let iso8601 = Formatter.iso8601
        decoder.dateDecodingStrategy = .custom({ decoder in
            let container = try decoder.singleValueContainer()
            let str = try container.decode(String.self)
            if let date = iso8601ms.date(from: str) {
                return date
            }
            if let date = iso8601.date(from: str) {
                return date
            }
            throw EchoToolboxError.format("unexpected date format: \(str)")
        })
        return decoder
    }
        
    // MARK: -
    
    var endpoint = defaultEndpoint
    var decoder = defaultDecoder
    var session = defaultSession
        
    public init() {}
    
    open class var shared: Toolbox {
        struct __ { static let _instance = Toolbox() }
        return __._instance
    }
}
