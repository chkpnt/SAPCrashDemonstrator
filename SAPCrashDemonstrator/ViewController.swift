//
//  ViewController.swift
//  SAPCrashDemonstrator
//
//  Created by Gregor Dschung on 26.09.17.
//  Copyright © 2017 Gregor Dschung. All rights reserved.
//

import UIKit
import os.log

class ViewController: UIViewController {
    
    private var logonCore: MAFLogonCore?
    private var logonContext: MAFLogonContext?
    
    // Adopt these constants to match the application on you smp-server
    private let applicationId = "..."
    private let smpServer = "..."
    private let credentials = URLCredential(user: "user", password: "password", persistence: .none)
    
    override func viewDidAppear(_ animated: Bool) {
        let ids = DataVault.dataVaultIds(forAccessGroup: nil).joined(separator: ", ")
        os_log("The following DataVault IDs are found: %@", ids)
    }
    
    @IBAction func didTapRegister(_ sender: Any) {
        let logonContext = createMAFLogonContext()
        self.logonContext = logonContext
        
        logonCore = MAFLogonCore(applicationId: applicationId)
        logonCore?.conversationManager = SMPHttpConversationManagerFactory().create(forCredentials: credentials)
        logonCore?.logonCoreDelegate = self
        logonCore?.register(with: logonContext)
    }
    
    @IBAction func didTapPersistRegistration(_ sender: Any) {
        try! logonCore!.persistRegistration("datavaultpw", logonContext: logonContext!)
    }
    
    @IBAction func didTapInitMAFLogon(_ sender: Any) {
        os_log("The registration is lost if it was made with a previous SDK.")
        os_log("The app crashes, if the app is reinstalled afterwards.")
        logonCore = MAFLogonCore(applicationId: applicationId)
        
        if logonCore?.state().isRegistered == true {
            os_log("According to LogonCore, the app is alreade registered")
        } else {
            os_log("LogonCore doesn't have information about the registration")
        }
    }
    
    
    func createMAFLogonContext() -> MAFLogonContext {
        let logonCTX = MAFLogonContext()
        logonCTX.registrationContext = createRegistrationContext()
        logonCTX.passwordPolicy = createPasswordPolicy()
        return logonCTX
    }
    
    private func createRegistrationContext() -> MAFLogonRegistrationContext {
        let regContext = MAFLogonRegistrationContext()
        regContext.applicationId = applicationId
        regContext.serverHost = smpServer
        regContext.isHttps = false
        regContext.serverPort = 8080
        regContext.backendUserName = credentials.user
        regContext.backendPassword = credentials.password
        return regContext
    }
    
    private func createPasswordPolicy() -> MAFSecureStorePasswordPolicy {
        let passwordPolicy = MAFSecureStorePasswordPolicy()
        passwordPolicy.minLength = 4
        passwordPolicy.minUniqueChars = 1
        passwordPolicy.hasDigits = false
        passwordPolicy.hasLowerCaseLetters = false
        passwordPolicy.hasUpperCaseLetters = false
        passwordPolicy.isEnabled = true
        passwordPolicy.lockTimeout = 12 * 60 * 60 // 12h
        passwordPolicy.retryLimit = 5000
        passwordPolicy.expirationDays = 99999
        passwordPolicy.isDefaultPasswordAllowed = true
        return passwordPolicy
    }
}

extension ViewController: MAFLogonCoreDelegate {
    func registerFinished(_ error: Error?) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        } else {
            os_log("Registration finished")
        }
    }
    
    func unregisterFinished(_ error: Error!) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func cancelRegistrationFinished(_ error: Error!) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func refreshApplicationSettingsFinished(_ error: Error!) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func changePasswordFinished(_ error: Error!) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        }
    }
    
    func uploadTraceFinished(_ error: Error!) {
        if let error = error {
            os_log("%@", error.localizedDescription)
        }
    }
    
    
}
