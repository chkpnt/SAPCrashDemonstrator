//
//  Logger.swift
//  SAPCrashDemonstrator
//
//  Created by Gregor Dschung on 02.05.18.
//  Copyright © 2018 Gregor Dschung. All rights reserved.
//

import Foundation

var log = Logger()

class Logger {
    
    private let fileName: String = "ClientLog.txt"
    private let loggerId: String = "SAPCrashDemonstrator.SMPLogger"
    
    private var smpLog: SAPClientLogger?
    var isSMPClientLogEnabled: Bool {
        return smpLog != nil
    }
    
    private var smpClientLogPath: String? {
        guard let documentsDirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.path else {
            return nil
        }
        return "\(documentsDirPath)/\(fileName)"
    }
    
    required init() {
        enableSMPClientLog()
    }
    
    func info(_ log: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        let message = formatForClientLog(log, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        print(message)
        smpLog?.logInfo(message)
    }
    
    func error(_ log: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        let message = formatForClientLog(log, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        print(message)
        smpLog?.logError(message)
    }
    
    func debug(_ log: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        let message = formatForClientLog(log, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        print(message)
        smpLog?.logDebug(message)
    }
    
    func severe(_ log: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        let message = formatForClientLog(log, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        print(message)
        smpLog?.logFatal(message)
    }
    
    func warning(_ log: String, functionName: StaticString = #function, fileName: StaticString = #file, lineNumber: Int = #line) {
        let message = formatForClientLog(log, functionName: functionName, fileName: fileName, lineNumber: lineNumber)
        print(message)
        smpLog?.logWarning(message)
    }
    
    private func formatForClientLog(_ log: String, functionName: StaticString, fileName: StaticString, lineNumber: Int) -> String {
        let baseName = (String(describing: fileName) as NSString).lastPathComponent
        return "[\(baseName):\(lineNumber)] \(functionName) > \(log)"
    }
    
    
    private func smpClientLogManager() -> SAPClientLogManager? {
        let logManager = SAPSupportabilityFacade.sharedManager().getClientLogManager()
        logManager?.setLogDestination(E_CLIENT_LOG_DESTINATION.FILESYSTEM, forIdentifier: loggerId)
        return logManager
    }
    
    func enableSMPClientLog() {
        smpLog = SAPSupportabilityFacade.sharedManager().getClientLogger(loggerId)
    }
    
    func disableSMPClientLog() {
        smpLog = nil
    }
    
    func uploadLog() -> Bool {
        let fileWritten = writeLogToFile()
        // upload file ...
        return fileWritten
    }
    
    
    private func writeLogToFile() -> Bool {
        guard let smpClientLogPath = smpClientLogPath else {
            log.error("Could not find the path to write the Logfile. Wrong path.")
            return false
        }
        
        var logStream = OutputStream(toFileAtPath: smpClientLogPath, append: false)
        
        do {
            
            guard let logManager = smpClientLogManager() else {
                log.info("SMP Log manager is empty. There is no data to write into file")
                return false
            }
            // 
            _ = try logManager.getLogEntries(forLogger: loggerId, with: E_CLIENT_LOG_LEVEL.ErrorClientLogLevel, outputStream: &logStream)
            
        } catch {
            log.error("Could not write content of SMP Log Manager into file")
        }
        
        return true
    }
    
}
