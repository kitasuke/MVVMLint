//
//  FileManagableTestCase.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/12/17.
//

import Foundation
import XCTest

class FileManagableTestCase: XCTestCase {
    let foldername = UUID().uuidString
    var tempDirectory: URL {
        return URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(foldername, isDirectory: true)
    }

    override func setUp() {
        super.setUp()

        try! FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }

    override func tearDown() {
        super.tearDown()

        try! FileManager.default.removeItem(at: tempDirectory)
    }
}
