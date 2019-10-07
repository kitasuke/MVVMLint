//
//  FileIterator.swift
//  MVVMLintCore
//
//  Created by Yusuke Kita on 2019/10/02.
//

import Foundation

// FileIterator is an iterator of all files of ViewController and ViewModel
public struct FileIterator: Sequence, IteratorProtocol {

    public let paths: [String]
    private var currentDirectory = ""
    private var pathIterator: Array<String>.Iterator
    private var directoryIterator: FileManager.DirectoryEnumerator?

    public init(paths: [String]) {
        self.paths = paths
        self.pathIterator = paths.makeIterator()
    }

    public mutating func next() -> File? {
        var file: File?
        while file == nil {
            if directoryIterator != nil {
                file = nextInDirectory()
            } else {
                guard let nextPath = pathIterator.next() else {
                    return nil
                }

                if FileManager.default.isDirectory(atPath: nextPath) {
                    setDirectoryIterator(of: nextPath)
                } else {
                    guard isValidPath(for: nextPath) else {
                        continue
                    }
                    file = File(path: nextPath)
                }
            }
        }
        return file
    }

    private mutating func nextInDirectory() -> File? {
        var file: File?
        defer {
            if file == nil {
                setDirectoryIterator(of: nil)
            }
        }

        while file == nil {
            guard let pathInDirectory = directoryIterator?.nextObject() as? String else {
                break
            }

            let filePath = absolutePath(for: pathInDirectory)
            guard FileManager.default.isFile(atPath: filePath) &&
                isValidPath(for: filePath, pathInDirectory: pathInDirectory) else {
                continue
            }

            file = File(path: filePath)
        }
        return file
    }

    private func absolutePath(for path: String) -> String {
        return [currentDirectory, "/", path].joined()
    }

    private func isValidPath(for path: String, pathInDirectory: String? = nil) -> Bool {
        guard path.hasSuffix(".\(File.extension)"),
            !path.contains("Tests") else {
            return false
        }

        let url = URL(fileURLWithPath: path)
        let lastPathComponent = url.deletingPathExtension().lastPathComponent
        guard [FileKind.viewModel.identifier, FileKind.viewController.identifier].contains(where: { lastPathComponent.hasSuffix($0) }) else {
            return false
        }
        return true
    }

    private mutating func setDirectoryIterator(of path: String?) {
        if let path = path {
            directoryIterator = FileManager.default.enumerator(atPath: path)
            currentDirectory = path
        } else {
            directoryIterator = nil
            currentDirectory = ""
        }
    }
}

extension FileManager {
    fileprivate func isFile(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) &&
            !isDirectory.boolValue
    }

    fileprivate func isDirectory(atPath path: String) -> Bool {
        var isDirectory: ObjCBool = false
        return FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory) &&
            isDirectory.boolValue
    }
}
