//
//  FileScannerTests.swift
//  MVVMLinterCoreTests
//
//  Created by Yusuke Kita on 2019/10/03.
//

import XCTest
@testable import MVVMLinterCore

class FileScannerTests: XCTestCase {

    func test_fileScan() {

        let base = "~/MVVMLint/"
        let `extension` = ".swift"
        let paths = [
                "FooViewModel",
                "FooViewController",
                "BarViewModel",
                "BazViewController",
            ]
            .map { [base, $0, `extension`].joined() }

        let scanner = FileScanner(paths: paths)
        let pairs = scanner.scan()

        XCTAssert(pairs.count == 1)
        XCTAssertEqual(
            pairs.map { $0.files.map { $0.path } },
            [["FooViewModel", "FooViewController"].map { [base, $0, `extension`].joined() }]
        )
    }
}
