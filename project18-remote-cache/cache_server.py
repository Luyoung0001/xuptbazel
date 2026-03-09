#!/usr/bin/env python3
"""简单的 HTTP 缓存服务器，符合 Bazel 远程缓存协议"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import os
import hashlib

CACHE_DIR = "/tmp/bazel-remote-cache"
os.makedirs(CACHE_DIR, exist_ok=True)

class CacheHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        """处理缓存读取请求"""
        cache_key = self.path.strip('/')
        cache_file = os.path.join(CACHE_DIR, cache_key)

        if os.path.exists(cache_file):
            self.send_response(200)
            self.end_headers()
            with open(cache_file, 'rb') as f:
                self.wfile.write(f.read())
            print(f"Cache HIT: {cache_key[:16]}...")
        else:
            self.send_response(404)
            self.end_headers()
            print(f"Cache MISS: {cache_key[:16]}...")

    def do_PUT(self):
        """处理缓存写入请求"""
        cache_key = self.path.strip('/')
        cache_file = os.path.join(CACHE_DIR, cache_key)

        content_length = int(self.headers['Content-Length'])
        data = self.rfile.read(content_length)

        with open(cache_file, 'wb') as f:
            f.write(data)

        self.send_response(200)
        self.end_headers()
        print(f"Cache STORE: {cache_key[:16]}... ({len(data)} bytes)")

if __name__ == '__main__':
    server = HTTPServer(('localhost', 8080), CacheHandler)
    print("缓存服务器运行在 http://localhost:8080")
    print(f"缓存目录: {CACHE_DIR}")
    server.serve_forever()
