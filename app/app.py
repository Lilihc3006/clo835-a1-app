import os
from flask import Flask
from markupsafe import Markup

app = Flask(__name__)

@app.route('/')
def home():
    color = os.environ.get('COLOR', 'blue')
    hostname = os.uname().nodename
    html = f'''
    <html>
      <head><title>CLO835 Color App</title></head>
      <body style="margin:0; height:100vh; display:flex; align-items:center; justify-content:center; background:{color}; color:white; font-family:Arial, sans-serif;">
        <div style="text-align:center">
          <h1>Hello from the <b>{color.upper()}</b> app!</h1>
          <p>Container hostname: <code>{hostname}</code></p>
          <p>Listening on container port 8080 (host ports 8081/8082/8083 via -p).</p>
        </div>
      </body>
    </html>
    '''
    return Markup(html)

if __name__ == '__main__':
    port = int(os.environ.get('PORT', '8080'))
    app.run(host='0.0.0.0', port=port)
