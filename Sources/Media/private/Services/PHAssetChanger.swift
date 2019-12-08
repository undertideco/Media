//
//  PHAssetChanger.swift
//  
//
//  Created by Christian Elies on 01.12.19.
//

import Photos

// TODO: OSX 10.13
@available(macOS 10.15, *)
struct PHAssetChanger {
    static var photoLibrary: PhotoLibrary = PHPhotoLibrary.shared()

    static func createRequest<T: MediaProtocol>(_ request: @escaping () -> PHAssetChangeRequest?,
                                                _ completion: @escaping (Result<T, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        var placeholderForCreatedAsset: PHObjectPlaceholder?
        photoLibrary.performChanges({
            let creationRequest = request()
            if let placeholder = creationRequest?.placeholderForCreatedAsset {
                placeholderForCreatedAsset = placeholder
            }
        }, completionHandler: { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? MediaError.unknown))
            } else {
                if let localIdentifier = placeholderForCreatedAsset?.localIdentifier, let item = T.with(identifier: Media.Identifier(stringLiteral: localIdentifier)) {
                    completion(.success(item))
                } else {
                    completion(.failure(MediaError.unknown))
                }
            }
        })
    }

    static func favorite(phAsset: PHAsset, favorite: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        guard Media.isAccessAllowed else {
            completion(.failure(Media.currentPermission.permissionError ?? PermissionError.unknown))
            return
        }

        photoLibrary.performChanges({
            let assetChangeRequest = PHAssetChangeRequest(for: phAsset)
            assetChangeRequest.isFavorite = favorite
        }) { isSuccess, error in
            if !isSuccess {
                completion(.failure(error ?? MediaError.unknown))
            } else {
                completion(.success(()))
            }
        }
    }
}
