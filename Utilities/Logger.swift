//
//  Logger.swift
//  alberta
//
//  Created by Stanislav Kasprik on 06/12/2017.
//  Copyright © 2017 Stanislav Kasprik. All rights reserved.
//

import XCGLogger

internal var log: XCGLogger = {
    let logger = XCGLogger.default
    logger.setup(level: .debug, showLogIdentifier: false, showFunctionName: true, showThreadName: true, showLevel: true, showFileNames: true, showLineNumbers: true, showDate: true, writeToFile: nil, fileLevel: .debug)
    
    // Add basic app info, version info etc, to the start of the logs
    logger.logAppDetails()
    
    // Default date formatter
    let defaultDateFormatter = DateFormatter()
    defaultDateFormatter.locale = NSLocale.current
    defaultDateFormatter.dateFormat = "HH:mm:ss.SSS"
    
    logger.dateFormatter = defaultDateFormatter
    
    logger.levelDescriptions = [
        .verbose: "💜", // Very verbose messages, long, unnecessary info. Message body, buffers, etc.
        .debug : "💙", // Standard debug messages. UI clicks, steps in functions
        .info: "ℹ️", // Connection or status change messages. E.G received Offer, received message, state changed from offline to online...
        .warning: "⚠️", // Warning messages, state changed to offline
        .error : "🛑", // all errors where app will survive, screen might need to close etc.
        .severe : "‼️ FATAL:" ] // This will crash app.
    
    return logger
}()

