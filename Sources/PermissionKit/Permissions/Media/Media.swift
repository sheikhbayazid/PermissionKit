//
//  Media.swift
//  PermissionKit
//
//  Created by Sheikh Bayazid on 2023-10-11.
//

import AVFoundation
import Combine
import Foundation

extension PermissionKit {
    func requestMediaPermission(mediaType: AVMediaType) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: mediaType)

            switch authorizationStatus {
            case .authorized:
                promise(.success(true))

            case .notDetermined:
                // Media permission has not been requested yet. So, request permission.
                AVCaptureDevice.requestAccess(for: mediaType) { granted in
                    promise(.success(granted))
                }

            case .denied:
                promise(.failure(MediaPermissionError.denied))

            case .restricted:
                promise(.failure(MediaPermissionError.restricted))

            @unknown default:
                promise(.failure(MediaPermissionError.unknown))
            }
        }
        .eraseToAnyPublisher()
    }
}
