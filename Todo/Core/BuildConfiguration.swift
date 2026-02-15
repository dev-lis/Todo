//
//  BuildConfiguration.swift
//  Todo
//
//  Created by Aleksandr Lis on 15.02.2026.
//

import Foundation

enum BuildConfiguration {

    #if DEV
    static let isDev = true
    static let isStage = false
    #elseif STAGE
    static let isDev = false
    static let isStage = true
    #else
    static let isDev = false
    static let isStage = false
    #endif
}
