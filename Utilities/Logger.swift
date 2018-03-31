//
//  Logger.swift
//  GlyphMaker
//
//  Created by Patrik Hora on 06/03/2018.
//  Copyright © 2018 Manicek. All rights reserved.
//

import XCGLogger

internal var log: XCGLogger = {
    let logger = XCGLogger.default
    logger.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: false, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: .debug)
    
    // Add basic app info, version info etc, to the start of the logs
    logger.logAppDetails()
    
    // Default date formatter
    let defaultDateFormatter = DateFormatter()
    defaultDateFormatter.locale = NSLocale.current
    defaultDateFormatter.dateFormat = "HH:mm:ss.SSS"
    
    logger.dateFormatter = defaultDateFormatter
    
    logger.levelDescriptions = [
        .verbose: "💜", // Very verbose messages, long, unnecessary info
        .debug : "💙", // Standard debug messages. UI clicks, steps in functions
        .warning: "⚠️", // Warning messages
        .error : "🛑", // Errors
        .severe : "‼️ FATAL:" ] // Crashes.
    
    return logger
}()

