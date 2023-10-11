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
