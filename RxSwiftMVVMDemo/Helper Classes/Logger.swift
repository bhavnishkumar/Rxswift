//
//  Logger.swift
//  RxSwiftMVVMDemo
//
//  Created by Bhavnish on 31/06/22.
//  Copyright © 2021 Bhavnish Mac. All rights reserved.
//

import Foundation

/**
Available Log level for Logger
- None:    Print no message
- Error:   Message of level Error
- Warning: Message of level Warning
- Success: Message of level Success
- Info:    Message of level Info
- Custom:  Message of level Custom
*/
enum LoggerLevels: Int {

    case none = 0
    case error
    case warning
    case success
    case info
    case custom
}

enum PathLengths: Int {

    case none = 0
    case short
    case long
}

/**
*  Singleton class to print custom log messages easier to read
*  and analize. Based in glyphs and log levels
*/
class Logger {

    // MARK: - Properties
    var verbosityLevel: LoggerLevels = .custom
    var verbosityLevels = [[LoggerLevels: Bool]]()
    var pathLength: PathLengths = .long
    var timeStampState: Bool = false
    var errorGlyph: String = "\u{1F6AB}"    // Glyph for messages of level .Error
    var warningGlyph: String = "\u{1F514}"  // Glyph for messages of level .Warning
    var successGlyph: String = "\u{2705}"   // Glyph for messages of level .Success
    var infoGlyph: String = "\u{1F535}"     // Glyph for messages of level .Info
    var customGlyph: String = "\u{1F536}"   // Glyph for messages of level .Custom
    // MARK: Public methods
    /**
    Prints a formatted message through the debug console,
    showing a glyph based on the loglevel and the name of the file
    invoking it if present
    :param: message      Message to print
    :param: logLevel     Level of the log message
    :param: file         Implicit parameter, file calling the method
    :param: method       Implicity parameter, method that was called
    :param: line         Implicit parameter, line which the call was made
    */
    func logMessage(message: String, _ logLevel: LoggerLevels = .info, file: String = #file, method: String = #function, line: UInt = #line) {

        var outputMessage: String = ""
        self.verbosityLevels.append([.custom: true])
        
        if self.verbosityLevel.rawValue > LoggerLevels.none.rawValue && logLevel.rawValue <= self.verbosityLevel.rawValue {
            switch self.pathLength.rawValue {
            case PathLengths.long.rawValue:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message) [\(file):\(line)] \(message)"
            case PathLengths.short.rawValue:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message) [\(NSURL(fileURLWithPath: file).deletingPathExtension!.lastPathComponent):\(method):\(line)]"
            default:
                outputMessage += "\(getGlyphForLogLevel(logLevel: logLevel))\(message)"
            }
            self.timeStampState ? print(outputMessage + " " + self.getTimeStamp()) : print(outputMessage)
        }
    }
    /**
    Prints a formatted message through the debug console,
    showing a glyph based on the loglevel and the name of the class
    invoking it if present
    :param: message      Message to print
    :param: logLevel     Level of the log message
    :param: file         Implicit parameter, file calling the method
    :param: line         Implicit parameter, line which the call was made
    :returns: A formatted string
    */
    func getMessage(message: StaticString, _ logLevel: LoggerLevels = .info, file: StaticString = #file, line: UInt = #line) -> String {

        return("\(getGlyphForLogLevel(logLevel: logLevel))\(message) [\(file):\(line)] \(message)")
    }
    /**
    Logs the given message as a custom message and
    check the condition of the assert.
    :param: condition Condition closure for the assert
    :param: message   Message to print
    :param: file      Implicit parameter, file calling the method
    :param: line      Implicit parameter, line which the call was made
    */
    func logMessageAndAssert(condition: @escaping () -> Bool, _ message: String, file: StaticString = #file, line: UInt = #line) {

        logMessage(message: message, .custom)
        assert(condition(), message.description, file: file, line: line)
    }

    // MARK: - Private Methods
    /**
    Returns the Glyph to use according to the passed LogLevel
    :param: logLevel
    :returns: A formatted string with the matching glyph
    */
    private func getGlyphForLogLevel(logLevel: LoggerLevels) -> String {
        switch logLevel {
        case .error:
            return "\(errorGlyph) "
        case .warning:
            return "\(warningGlyph) "
        case .success:
            return "\(successGlyph) "
        case .info:
            return "\(infoGlyph) "
        case .custom:
            return "\(customGlyph) "
        default:
            return " "
        }
    }
    /**
    Returns the current Time Stamp
    :returns: A formatted string with the current time stamp
    */
    private func getTimeStamp() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss.zzz"
        let timeStamp = dateFormatter.string(from: NSDate() as Date)
        return "[" + timeStamp + "]"
    }

    // MARK: - Thread Safe Singleton Pattern
    static let sharedInstance = Logger()
}
