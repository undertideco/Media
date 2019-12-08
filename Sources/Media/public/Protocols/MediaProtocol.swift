//
//  MediaProtocol.swift
//  Media
//
//  Created by Christian Elies on 21.11.19.
//  Copyright © 2019 Christian Elies. All rights reserved.
//

import Photos

/// Defines the requirements for a specific `Media`,
/// like a `LivePhoto` or `Video`
///
public protocol MediaProtocol {
    associatedtype MediaSubtype: MediaSubtypeProvider

    var phAsset: PHAsset { get }
    var identifier: Media.Identifier { get }
    static var type: MediaType { get }

    init(phAsset: PHAsset)

    // TODO: osx 10.13
    @available(macOS 10.15, *)
    static func with(identifier: Media.Identifier) -> Self?

    // TODO: osx 10.13
    @available(macOS 10.15, *)
    func delete(completion: @escaping (Result<Void, Error>) -> Void)
}

extension MediaProtocol {
    /// A unique identifier, currently the `localIdentifier` of the `phAsset`
    ///
    public var identifier: Media.Identifier { Media.Identifier(stringLiteral: phAsset.localIdentifier) }
}

// TODO: osx 10.13
@available(macOS 10.15, *)
extension MediaProtocol {
    /// Deletes the receiver if the access to the photo library is allowed
    ///
    /// Hint: asynchronously
    /// - Parameter completion: a closure which get's the `Result` (`Void` on `success` and `Error` on `failure`)
    ///
    public func delete(completion: @escaping (Result<Void, Error>) -> Void) {
        PHChanger.request({
            let phAssets: NSArray = [self.phAsset]
            PHAssetChangeRequest.deleteAssets(phAssets)
            return nil
        }, completion)
    }
}
