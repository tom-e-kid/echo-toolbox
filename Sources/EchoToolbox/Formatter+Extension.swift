//
//  Formatter+Extension.swift
//  echo-toolbox
//
//  Created by Tomohiko Ikeda on 2022/12/16.
//

import Foundation

extension Formatter {
    public static var iso8601: ISO8601DateFormatter {
        ISO8601DateFormatter()
    }
    
    public static var iso8601ms: ISO8601DateFormatter {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime,
                           .withDashSeparatorInDate,
                           .withColonSeparatorInTime,
                           .withTimeZone,
                           .withFractionalSeconds]
        return f
    }
}
