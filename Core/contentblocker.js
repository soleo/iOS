
/**

iOS blocks:

ContentBlocker BLOCKED https://lpcdn.lpsnmedia.net/le_secure_storage/3.3.0.2-release_294/storage.secure.min.html?loc=https%3A%2F%2Fwww.evanscycles.com&site=14779501&env=prod
ContentBlocker BLOCKED https://dis.eu.criteo.com/dis/dis.aspx?p=1498&cb=34837368626&ref=&sc_r=375x667&sc_d=32&site_type=m
ContentBlocker BLOCKED https://vars.hotjar.com/rcj-99d43ead6bdf30da8ed5ffcb4f17100c.html

Javascript blocks:

0 "https://lptag.liveperson.net/tag/tag.js?site=14779501"
1 "https://sslwidget.criteo.com/event?a=1498&v=4.4.5&p0=e%3Dexd%26ci%3D%26site_type%3Dm&p1=e%3Dvh%26si%3D%26ui_tcid%3D&p2=e%3Ddis&adce=1"
2 "https://script.hotjar.com/modules-f524bccd859bfc7e394e1123f7f90405.js"
3 "https://vars.hotjar.com/rcj-99d43ead6bdf30da8ed5ffcb4f17100c.html"
4 "https://loadeu.exelator.com/load/?p=462&g=060&j=d&ClientID=060&UserID=217090415414376960"

*/

decodeBase64 = function(s) {
    var e={},i,b=0,c,x,l=0,a,r='',w=String.fromCharCode,L=s.length;
    var A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    for(i=0;i<64;i++){e[A.charAt(i)]=i;}
    for(x=0;x<L;x++){
        c=e[s.charAt(x)];b=(b<<6)+c;l+=6;
        while(l>=8){((a=(b>>>(l-=8))&0xff)||(x<(L-2)))&&(r+=w(a));}
    }
    return r;
};

var easyListTxt = decodeBase64("${easylist_text}")

// var easyListTxt = function() {
// 
// }.toString().slice(16,-3);

// var easyListTxt = btoa("");

// dump first 100 characters
console.log(easyListTxt.slice(0, 100));

var parsedFilterData = {};
// var urlToCheck = 'http://static.tumblr.com/dhqhfum/WgAn39721/cfh_header_banner_v2.jpg';

// This is the site who's URLs are being checked, not the domain of the URL being checked.
// var currentPageDomain = 'slashdot.org';

ABPFilterParser.parse(easyListTxt, parsedFilterData);
// ABPFilterParser.parse(someOtherListOfFilters, parsedFilterData);


var blocked = []
var rules = ${rules}

var count = 0
var size = 0
for (var property in rules) {
	size += property.length;
	count++;
}

console.log(count + " rules @ " + size + "bytes");

document.addEventListener("beforeload", function(event) {
	console.log("Checking: " + event.url);

	try {

		var url = new URL(event.url);
		var hostnameParts = url.hostname.split(".");
		var max = hostnameParts.length;

		for (var i = max - 2; i >= 0; i--) {
			var hostname = hostnameParts.slice(i, max).join(".");

			if (rules[hostname]) {
				console.warn("Disconnect did block: " + event.url);
                webkit.messageHandlers.trackerBlockedMessage.postMessage(event.url);
				blocked.push(event.url);
				event.preventDefault();
				event.stopPropagation();
                return;
			}
            console.log("Disconnect did NOT block: " + event.url);
		}

		if (ABPFilterParser.matches(parsedFilterData, event.url, {
			domain: document.location.hostname,
			elementTypeMaskMap: ABPFilterParser.elementTypeMaskMap,
		})) {
            console.warn("ABP did block: " + event.url);
            webkit.messageHandlers.trackerBlockedMessage.postMessage(event.url);
            blocked.push(event.url);
            event.preventDefault();
            event.stopPropagation();
		} else {
			console.log("ABP did NOT block: " + event.url);
		}


	} catch (err) {
		console.log("Error " + event.url + "\n" + err)
	}

}, true);
