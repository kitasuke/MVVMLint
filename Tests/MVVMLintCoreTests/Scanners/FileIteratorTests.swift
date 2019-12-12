//
//  FileIteratorTests.swift
//  MVVMLintCoreTests
//
//  Created by Yusuke Kita on 2019/10/03.
//

import XCTest
@testable import MVVMLintCore

final class FileIteratorTests: XCTestCase {

    func test_fileIteration() {
        let base = "~/MVVMLint/"
        let paths = [
                "ViewModel.swift",
                "ViewController.swift",
                "View.swift",
                "Model.swift",
                "ViewModelTests.swift",
                "ViewControllerTests.swift",
                "ViewController.h",
                "ViewController.h"
            ]
            .map { [base, $0].joined() }
        let iterator = FileIterator(paths: paths)
        let targetPaths = iterator.map { $0 }
        XCTAssertEqual(
            targetPaths,
            ["ViewModel.swift", "ViewController.swift"].map { [base, $0].joined() }
        )
    }
}
