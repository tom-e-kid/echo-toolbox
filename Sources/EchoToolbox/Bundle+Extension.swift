//
//  Bundle+Extension.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

extension Bundle {
    public func data(named name: String) throws -> Data {
        guard let url = url(forResource: name, withExtension: "json") else {
            throw EchoToolboxError.badRequest("failed to locate \(name).json in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            throw EchoToolboxError.badRequest("failed to load \(name) in bundle.")
        }
        return data
    }
}
