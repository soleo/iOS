//
//  URLProtocol.swift
//  DuckDuckGo
//
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//


import Foundation
import Core


class URLProtocol: Foundation.URLProtocol {
    
    struct Constants {
        static let requestHandledKey = "com.duckduckgo.url.requesthandled"
    }
    
    var connection: NSURLConnection?
    
    
    override class func canInit(with request: URLRequest) -> Bool {
        Logger.log(text: "URLProtocol observed \(request.url?.absoluteString ?? "")")
        if URLProtocol.property(forKey: Constants.requestHandledKey, in: request) != nil {
            return false
        }
        return false // make true to intercept
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return super.requestIsCacheEquivalent(aRequest, to:bRequest)
    }
    
    override func startLoading() {
        Logger.log(text: "URLProtocol loading \(request.url?.absoluteString ?? "")")
        let urlRequest = request as NSURLRequest
        guard let mutableUrlRequest = urlRequest.mutableCopy() as? NSMutableURLRequest else {
            return
        }
        URLProtocol.setProperty(true, forKey: Constants.requestHandledKey, in: mutableUrlRequest)
        connection = NSURLConnection(request: mutableUrlRequest as URLRequest, delegate: self)
    }
    
    override func stopLoading() {
        connection?.cancel()
        connection = nil
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func connectionDidFinishLoading(_ connection: NSURLConnection!) {
        client?.urlProtocolDidFinishLoading(self)
    }
    
    func connection(connection: NSURLConnection!, didFailWithError error: NSError!) {
        client?.urlProtocol(self, didFailWithError: error)
    }
}
