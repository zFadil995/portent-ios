//
//  PortentURLSession.swift
//  portent
//

import Foundation

/// Factory for URLSession configured per ServiceInstance.
enum PortentURLSession {
    /// Creates a URLSession for the given instance.
    /// Uses trust-all delegate when instance has ignoreSslErrors enabled.
    static func session(for instance: ServiceInstance) -> URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 30
        config.timeoutIntervalForResource = 60

        if instance.ignoreSslErrors {
            // WARNING: Only use for user-configured self-signed cert instances
            let delegate = TrustAllCertificatesDelegate()
            return URLSession(configuration: config, delegate: delegate, delegateQueue: nil)
        }

        return URLSession(configuration: config)
    }
}

// WARNING: Only use for user-configured self-signed cert instances
private final class TrustAllCertificatesDelegate: NSObject, URLSessionDelegate {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust,
              let serverTrust = challenge.protectionSpace.serverTrust
        else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        let credential = URLCredential(trust: serverTrust)
        completionHandler(.useCredential, credential)
    }
}
