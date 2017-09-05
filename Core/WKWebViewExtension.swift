//
//  WKWebView.swift
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


import WebKit
import SwiftyJSON

extension WKWebView {

    public static func createWebView(frame: CGRect, persistsData: Bool) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        if !persistsData {
            configuration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        }
        if #available(iOSApplicationExtension 10.0, *) {
            configuration.dataDetectorTypes = [.link, .phoneNumber]
        }
        let webView = WKWebView(frame: frame, configuration: configuration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return webView
    }
    
    public func loadScripts() {
        load(scripts: [.document, .favicon])

        guard let trackers = TrackerLoader.shared.storedTrackers else {
            return
        }

        var trackerUrls = [String: Any]()
        for tracker in trackers {
            trackerUrls[tracker.url] = true
            if let parentDomain = tracker.parentDomain {
                trackerUrls[parentDomain] = true
            }
        }

        let json = try! JSON(data: JSONSerialization.data(withJSONObject: trackerUrls, options: .prettyPrinted))
        let bundle = Bundle(for: JavascriptLoader.self)
        let path = bundle.path(forResource: "contentblocker", ofType: "js")!
        let raw = try! String(contentsOfFile: path)
        let js = raw.replacingOccurrences(of: "${rules}", with: "\(json)")
        let script = WKUserScript(source: js, injectionTime: .atDocumentStart, forMainFrameOnly: false)
        configuration.userContentController.addUserScript(script)

    }

    private func load(scripts: [JavascriptLoader.Script]) {
        let javascriptLoader = JavascriptLoader()
        for script in scripts {
            javascriptLoader.load(script, withController: configuration.userContentController)
        }
    }
    
    public func getUrlAtPoint(x: Int, y: Int, completion: @escaping (URL?) -> Swift.Void) {
        let javascript = "duckduckgoDocument.getHrefFromPoint(\(x), \(y))"
        evaluateJavaScript(javascript) { (result, error) in
            if let text = result as? String {
                let url = URL(string: text)
                completion(url)
            } else {
                completion(nil)
            }
        }
    }
    
    public func getUrlAtPointSynchronously(x: Int, y: Int) -> URL? {
        var complete = false
        var url: URL?
        let javascript = "duckduckgoDocument.getHrefFromPoint(\(x), \(y))"
        evaluateJavaScript(javascript) { (result, error) in
            if let text = result as? String {
                url = URL(string: text)
            }
            complete = true
        }
        
        while (!complete) {
            RunLoop.current.run(mode: .defaultRunLoopMode, before: .distantFuture)
        }
        return url
    }
    
    public func getFavicon(completion: @escaping (URL?) -> Swift.Void) {
        let javascript = "duckduckgoFavicon.getFavicon()"
        evaluateJavaScript(javascript) { (result, error) in
            guard let urlString = result as? String else { completion(nil); return }
            guard let url = URL(string: urlString) else { completion(nil); return }
            completion(url)
        }
    }
}
