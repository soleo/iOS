//
//  document.js
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


var duckduckgoDocument = function () {
    
    getHrefFromPoint = function(x, y) {
        var element = document.elementFromPoint(x, y);
        while (element && !element.href) {
            element = element.parentNode
        }
        return getHrefFromElement(element)
    };
    
    getHrefFromElement = function(element) {
        if (element) {
            return element.href
        }
        return null
    };

    deletePageCookies = function() {
        console.log("Deleting simple javascript cookies " + document.cookie)
        document.cookie.split(';').forEach(function(cookie) {
            console.log("Attempting to delete " + cookie)
            document.cookie = cookie.trim().split('=')[0] + '=;' + 'expires=Thu, 01 Jan 1970 00:00:00 UTC;';
        });
        console.log("Cookies remaining" + document.cookie)
    }
    
    return {
        getHrefFromPoint: getHrefFromPoint,
        getHrefFromElement: getHrefFromElement,
        deleteCookies: deletePageCookies
    };

}();
