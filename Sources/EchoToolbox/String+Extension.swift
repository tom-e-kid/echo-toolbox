//
//  Extensions.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

extension String {
    
    /// Convert string to json object
    public var jsonObject: Any? {
        if let d = data(using: .utf8) {
            return try? JSONSerialization.jsonObject(with: d)
        }
        return nil
    }
    
    public var isValidJSON: Bool {
        jsonObject != nil
    }
}
