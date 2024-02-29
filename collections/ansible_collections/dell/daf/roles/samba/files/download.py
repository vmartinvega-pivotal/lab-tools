from __future__ import unicode_literals
import yt_dlp
import sys
from flask import Flask
import yaml

app = Flask(__name__)

ydl_opts = {
    'format': 'bestvideo/best',
    'outtmpl': '/srv/samba/share/%(title)s.%(ext)s',
}

@app.route("/pornhub/<key>")
def download_pornhub(key):
    download('https://es.pornhub.com/view_video.php?viewkey=' + key)
    return "DOWNLOADED", 200

def download(url):
    ydl = yt_dlp.YoutubeDL(ydl_opts)
    ydl.download([url])

@app.route("/load")
def load():
    with open('config.yml', 'r') as file:
        config = yaml.safe_load(file)

    for url in config['urls']: 
        download(url)
    return "LOADED", 200

