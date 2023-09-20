//
//  PermissionKit.swift
//  PermissionKit
//
//  Created by Sheikh Bayazid on 20/9/23.
//

import AVFoundation
import Combine
import Foundation

public struct PermissionKit {
    public init() { }

    public func requestPermission(for type: PermissionType) -> AnyPublisher<Bool, Error> {
        switch type {
        case .camera:
            return requestMediaPermission(mediaType: .video)
        }
    }

    private func requestMediaPermission(mediaType: AVMediaType) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)

            switch authorizationStatus {
            case .authorized:
                promise(.success(true))

            case .notDetermined:
                // Media permission has not been requested yet.
                // Request permission.
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    if granted {
                        promise(.success(true))
                    } else {
                        promise(.success(false))
                    }
                }

            case .denied:
                promise(.failure(MeediaPermissionError.denied))

            case .restricted:
                promise(.failure(MeediaPermissionError.restricted))

            @unknown default:
                promise(.failure(MeediaPermissionError.unknown))
            }
        }
        .eraseToAnyPublisher()
    }
}
