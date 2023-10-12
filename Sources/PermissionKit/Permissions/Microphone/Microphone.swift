//
//  Microphone.swift
//  PermissionKit
//
//  Created by Sheikh Bayazid on 2023-10-12.
//

import AVFoundation
import Combine
import Foundation

extension PermissionKit {
    func requestMicrophonePermission(_ category: AVAudioSession.Category = .playAndRecord, mode: AVAudioSession.Mode = .default, options: AVAudioSession.CategoryOptions = []) -> AnyPublisher<Bool, Error> {
        Future { promise in
            let audioSession = AVAudioSession.sharedInstance()

            do {
                try audioSession.setCategory(category, mode: mode, options: options)
                try audioSession.setActive(true)

                audioSession.requestRecordPermission { granted in
                    promise(.success(granted))
                }
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    @available(iOS 17, *)
    func requestMicrophonePermissioniOS17() -> AnyPublisher<Bool, Error> {
        Future { promise in
            let audioApplication = AVAudioApplication.shared

            switch audioApplication.recordPermission {
            case .undetermined:
                AVAudioApplication.requestRecordPermission { granted in
                    promise(.success(granted))
                }

            case .denied:
                promise(.failure(MicrophonePermissionError.denied))

            case .granted:
                promise(.success(true))

            @unknown default:
                promise(.failure(MicrophonePermissionError.unknown))
            }
        }
        .eraseToAnyPublisher()
    }
}
