
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

console.log(ABP)

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
	console.log("checking: " + event.url);

	try {
		var url = new URL(event.url);
		var hostnameParts = url.hostname.split(".");
		var max = hostnameParts.length;

		for (var i = max - 2; i >= 0; i--) {
			var hostname = hostnameParts.slice(i, max).join(".");

			console.log("\tchecking: " + hostname);
			if (rules[hostname]) {
				console.warn("blocked: " + event.url);
				blocked.push(event.url);
				event.preventDefault();
				event.stopPropagation();
				break;
			}
		}

	} catch (err) {
		console.log("error checking " + event.url)		
	}

}, true);
