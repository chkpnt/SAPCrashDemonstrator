//
//  SMPHttpConversationManagerFactory.swift
//  SAPCrashDemonstrator
//
//  Created by Gregor Dschung on 07.06.18.
//  Copyright © 2018 Gregor Dschung. All rights reserved.
//

class SMPHttpConversationManagerFactory {
    
    func create(forCredentials credentials: URLCredential) -> HttpConversationManager {
        let conversationManager: HttpConversationManager = HttpConversationManager()

        let authenticationConfigurator = CommonAuthenticationConfigurator()
        authenticationConfigurator.addUsernamePasswordProvider(SMPUsernamePasswordProvider(credentials: credentials))
        authenticationConfigurator.configureManager(conversationManager)
        
        return conversationManager
    }
}
