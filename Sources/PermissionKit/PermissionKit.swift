//
//  PermissionKit.swift
//  PermissionKit
//
//  Created by Sheikh Bayazid on 20/9/23.
//

import Combine
import Foundation

public struct PermissionKit {
    public init() { }

    public func requestPermission(for type: PermissionType) -> AnyPublisher<Bool, Error> {
        switch type {
        case .camera:
            return requestMediaPermission(mediaType: .video)

        case .microphone:
            if #available(iOS 17, *) {
                return requestMicrophonePermissioniOS17()
            }
            return requestMicrophonePermission()
        }
    }
}
