//
//  Data+Extension.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

extension Data {
    public func decode<T: Decodable>(_ t: T.Type, decoder: JSONDecoder) throws -> T {
        try decoder.decode(t.self, from: self)
    }
    
    public func anyJson() throws -> Any {
        try JSONSerialization.jsonObject(with: self)
    }
}
