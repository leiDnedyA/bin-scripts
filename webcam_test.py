#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import sys
import threading
import webbrowser


HOST = "localhost"
PORT = 5151
URL = f"http://{HOST}:{PORT}"

HTML = """<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Webcam Test</title>
  <style>
    html, body {
      margin: 0;
      width: 100%;
      height: 100%;
      background: #000;
      overflow: hidden;
    }

    video {
      display: block;
      width: 100vw;
      height: 100vh;
      background: #000;
      object-fit: contain;
    }

    #status {
      position: fixed;
      left: 12px;
      bottom: 12px;
      max-width: calc(100vw - 24px);
      box-sizing: border-box;
      color: #fff;
      background: rgba(0, 0, 0, 0.65);
      font: 14px system-ui, sans-serif;
      padding: 6px 8px;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <video autoplay playsinline muted></video>
  <div id="status">Allow camera access to test the webcam.</div>

  <script>
    const video = document.querySelector("video");
    const status = document.querySelector("#status");

    async function startWebcam() {
      if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
        status.textContent = "This browser does not support webcam access.";
        return;
      }

      try {
        const stream = await navigator.mediaDevices.getUserMedia({
          video: true,
          audio: false
        });

        video.srcObject = stream;
        await video.play();
        status.hidden = true;
      } catch (error) {
        status.textContent = error && error.message
          ? error.message
          : "Could not access webcam.";
      }
    }

    startWebcam();
  </script>
</body>
</html>
""".encode("utf-8")


class WebcamHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path in ("/", "/index.html"):
            self.send_response(200)
            self.send_header("Content-Type", "text/html; charset=utf-8")
            self.send_header("Content-Length", str(len(HTML)))
            self.send_header("Cache-Control", "no-store")
            self.send_header("Permissions-Policy", "camera=(self)")
            self.end_headers()
            self.wfile.write(HTML)
            return

        self.send_error(404)

    def log_message(self, format, *args):
        sys.stderr.write("%s - %s\n" % (self.address_string(), format % args))


def main():
    try:
        server = ThreadingHTTPServer((HOST, PORT), WebcamHandler)
    except OSError as error:
        print(f"Could not start server on {URL}: {error}", file=sys.stderr)
        return 1

    threading.Timer(0.25, webbrowser.open, args=(URL,), kwargs={"new": 2}).start()
    print(f"Serving webcam test at {URL}")

    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nStopped.")
    finally:
        server.server_close()

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
