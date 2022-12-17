//
//  Formatter+ExtensionTests.swift
//  
//
//  Created by Tomohiko Ikeda on 2022/12/17.
//

import XCTest
@testable import EchoToolbox

final class Formatter_ExtensionTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testIso8601() throws {
        let f = Formatter.iso8601
        let d1 = f.date(from: "2022-12-24T00:00:00Z")
        XCTAssertNotNil(d1)
        let d2 = f.date(from: "2022-12-24T09:00:00+09:00")
        XCTAssertNotNil(d2)
        XCTAssertEqual(d1, d2)
    }
    
    func testIso8601ms() throws {
        let f = Formatter.iso8601ms
        let d1 = f.date(from: "2022-12-24T00:00:00.000Z")
        XCTAssertNotNil(d1)
        let d2 = f.date(from: "2022-12-24T09:00:00.000+09:00")
        XCTAssertNotNil(d2)
        XCTAssertEqual(d1, d2)
    }
}
