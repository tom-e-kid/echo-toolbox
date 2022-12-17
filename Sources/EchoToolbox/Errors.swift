//
//  Errors.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

public enum EchoToolboxError: Error {
    case badRequest(String)
    case format(String)
    case decode(String)
    case serviceResponse(Data)
    case unknown(String)
}
