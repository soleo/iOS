//
//  CacheMonitor.swift
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

public struct PageMonitor {
    
    public private(set) var hosts = Set<String>()
    
    mutating func log(request: URLRequest) {
        guard let url = request.url else { return }
        log(visitedUrl: url)
    }
    
    mutating func log(response: URLResponse) {
        guard let url = response.url else { return }
        log(visitedUrl: url)
        
        if let response = response as? HTTPURLResponse,
           let headers = response.allHeaderFields as? [String: String] {
            logCookies(fromHeaders: headers, url: url)
        }
    }
    
    private mutating func log(visitedUrl: URL) {
        Logger.log(text: "PageMonitor monitored url \(visitedUrl)")
        if let host = visitedUrl.host {
            hosts.insert(host)
        }
    }
    
    private mutating func log(cookies: [HTTPCookie]) {
        let newHosts = cookies.map { $0.domain }
        Logger.log(text: "PageMonitor monitored cookies for hosts \(newHosts)")
        hosts = hosts.union(newHosts)
    }
    
    private mutating func logCookies(fromHeaders headers: [String: String], url: URL) {
        let cookies = HTTPCookie.cookies(withResponseHeaderFields:headers, for: url)
        if !cookies.isEmpty {
            log(cookies: cookies)
        }
    }
}
