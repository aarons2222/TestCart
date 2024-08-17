//
//  Logger.swift
//
//
//  Created by Aaron Strickland on 16/08/2024.
//

import Foundation

/// Different levels of logging available.
enum LogLevel: String {
    case debug = "DEBUG"    // For detailed debugging info
    case info = "INFO"      // For general information about the app's state
    case warning = "WARNING"// For warning messages about potential issues
    case error = "ERROR"    // For error messages when something goes wrong
}

/// A simple Logger class
/// Use this to log messages at various levels of severity.
class Logger {
    static let shared = Logger()  // The one and only instance of Logger

    /// The current level of logging. Only messages at this level or higher will be logged.
    var logLevel: LogLevel = .debug

    /// Private initialiser to make sure only one Logger instance exists.
    private init() {}

    /// Logs a message if the level is high enough to be logged.
    /// - Parameters:
    ///   - message: The message you want to log.
    ///   - level: The severity level of the log message.
    ///   - file: The name of the file where the log is called (default is the file name).
    ///   - function: The name of the function where the log is called (default is the function name).
    ///   - line: The line number in the file where the log is called (default is the line number).
    func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        // Check if we should log this message based on its level.
        guard shouldLog(for: level) else { return }
        
        // Get just the file name from the full path.
        let filename = (file as NSString).lastPathComponent
        
        // Format the log message with level, file, line, and function info.
        let logMessage = "[\(level.rawValue)] \(filename):\(line) \(function) - \(message)"
        
        // Print the log message to the console.
        print(logMessage)
    }

    /// Decides whether a message should be logged based on its level.
    /// - Parameter level: The severity level of the log message.
    /// - Returns: A boolean indicating whether the message will be logged.
    private func shouldLog(for level: LogLevel) -> Bool {
        // Only log the message if its level meets the current log level.
        switch logLevel {
        case .debug:
            return true  // Log everything if we're in debug mode.
        case .info:
            return level != .debug  // Log info, warning, and error messages.
        case .warning:
            return level == .warning || level == .error  // Log only warnings and errors.
        case .error:
            return level == .error  // Only log errors.
        }
    }
}
