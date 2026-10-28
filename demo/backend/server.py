from http.server import BaseHTTPRequestHandler, HTTPServer
import json


class Handler(BaseHTTPRequestHandler):

    def do_GET(self):
        if self.path == "/health":
            data = {"status": "ok"}
            self.send_response(200)
        elif self.path == "/api/notes":
            data = []
            self.send_response(200)
        else:
            data = {"message": "Backend funcionando"}
            self.send_response(200)

        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps(data).encode())


HTTPServer(("0.0.0.0", 5000), Handler).serve_forever()
