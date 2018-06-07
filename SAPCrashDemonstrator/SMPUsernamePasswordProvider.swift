//
//  SMPUsernamePasswordProvider.swift
//  SAPCrashDemonstrator
//
//  Created by Gregor Dschung on 07.06.18.
//  Copyright © 2018 Gregor Dschung. All rights reserved.
//

import os.log

class SMPUsernamePasswordProvider: NSObject, UsernamePasswordProviderProtocol {
    
    private var credentials: URLCredential
    
    init(credentials: URLCredential) {
       self.credentials = credentials
    }
    
    /**
     This method is invoked when a BasicAuth challenge is detected during the execution of a conversation. The specified block is to be invoked when the credentials are
     available or when the challenge handling cannot be fulfilled.
     
     @param authChallenge the authentication challenge initialized with username and password, must be non-nil
     @param completionBlock the block to invoke with the results, must be non-nil
     */
    func provideUsernamePassword(forAuthChallenge authChallenge: URLAuthenticationChallenge?, completionBlock: ((URLCredential?, Error?) -> Void)?) {
        guard let challenge = authChallenge,
            let complete = completionBlock else {
                completionBlock?(nil, nil)
                return
        }
        
        // Unfortunately, the SMP Server challenges again and again if the proposed
        // credentials don't match. So we are lost in a loop if we don't break out.
        // The SMP Server stops challenging only when we try to authenticate without credentials.
        guard challenge.previousFailureCount == 0 else {
            os_log("Sending no credentials to cancel authentication (authentication challenge has a failure count of %@", challenge.previousFailureCount)
            complete(nil, nil)
            return
        }
        
        complete(credentials, nil)
    }
}
