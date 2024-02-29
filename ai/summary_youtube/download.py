from __future__ import unicode_literals
import yt_dlp
import sys
from flask import Flask
import yaml

app = Flask(__name__)

ydl_opts = {
    'format': 'bestaudio/best',
    'outtmpl': '/srv/samba/share/%(title)s.%(ext)s',
}

@app.route("/download/<url>")
def download(url):
    ydl = yt_dlp.YoutubeDL(ydl_opts)
    ydl.download([url])
    return "DOWNLOADED", 200

@app.route("/load")
def load():
    with open('config.yml', 'r') as file:
        urls = yaml.safe_load(file)

    print(urls['prime_numbers'][0])
