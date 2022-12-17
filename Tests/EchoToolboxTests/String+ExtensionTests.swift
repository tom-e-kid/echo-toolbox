//
//  String+ExtensionTests.swift
//  
//
//  Created by Tomohiko Ikeda on 2022/12/17.
//

import XCTest
@testable import EchoToolbox

final class String_ExtensionTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    private let valid1 = """
    {
        "string": "value",
        "number": 123,
        "bool": true,
        "nested": {
            "array": [1, 2, 3]
        }
    }
    """
    
    private let valid2 = """
    [
        { "num": 100 },
        { "num": 200 },
    ]
    """
    
    private let invalid1 = """
    {
        "string": "value"
        "number": 123
    }
    """
    
    private let invalid2 = """
    invalid
    """
    
    func testJsonObject() throws {
        let dic = valid1.jsonObject as? [String: Any]
        XCTAssertNotNil(dic)
        let s = dic!["string"] as? String
        XCTAssertNotNil(s)
        XCTAssertEqual(s, "value")
        let n = dic!["number"] as? Int
        XCTAssertNotNil(n)
        XCTAssertEqual(n, 123)
        let b = dic!["bool"] as? Bool
        XCTAssertNotNil(b)
        XCTAssertEqual(b, true)
        let nested = dic!["nested"] as? [String: Any]
        XCTAssertNotNil(nested)
        let na = nested!["array"] as? [Int]
        XCTAssertNotNil(na)
        XCTAssertEqual(na, [1, 2, 3])
    }
    
    func testJsonObjectWithArray() throws {
        let array = valid2.jsonObject as? [[String: Int]]
        XCTAssertNotNil(array)
        XCTAssertEqual(array!.count, 2)
        XCTAssertEqual(array![0]["num"], 100)
        XCTAssertEqual(array![1]["num"], 200)
    }
    
    func testJsonObjectWithInvalidValues() throws {
        XCTAssertNil(invalid1.jsonObject)
        XCTAssertNil(invalid2.jsonObject)
    }
    
    func testIsValidJson() throws {
        XCTAssertTrue(valid1.isValidJSON)
        XCTAssertTrue(valid2.isValidJSON)
        XCTAssertFalse(invalid1.isValidJSON)
        XCTAssertFalse(invalid2.isValidJSON)
    }
}
