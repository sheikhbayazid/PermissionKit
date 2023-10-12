//
//  MediaPermissionError.swift
//  PermissionKit
//
//  Created by Sheikh Bayazid on 20/9/23.
//

import Foundation

public enum MediaPermissionError: Error {
    case denied
    case restricted
    case unknown
}
