import SimpleHTTPServer
import SocketServer
import sys

PORT = 8000

class CustomHTTPRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):

    def end_headers(self):
	self.send_header('Access-Control-Allow-Origin', '*')
	SimpleHTTPServer.SimpleHTTPRequestHandler.end_headers(self)

handler = CustomHTTPRequestHandler

httpd = SocketServer.TCPServer(("", PORT), handler)

print "serving at port", PORT
httpd.serve_forever()

