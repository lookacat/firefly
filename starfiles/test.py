import json
import youtube_dl
from youtube_search import YoutubeSearch
import tempfile
import os
import threading

print("DOING:")
try:
    os.makedirs('/data/data/com.example.flutterpython/files/tmp')
except:
    pass
f = tempfile.TemporaryFile(dir='/data/data/com.example.flutterpython/files/tmp')
print("FINE!")

class MyLogger(object):
    def debug(self, msg):
        pass
    def warning(self, msg):
        pass
    def error(self, msg):
        pass

#MEHR IN PYTHON SCHREIBEN FÜR GEMEINSAME CODEBASE
#TODO OPTIMIZE CALLS
#TODO: TEMPFILE dir in den Modulen anpassen!!!! (dir='/data/data/com.example.flutterpython/files/tmp')
class YouTubeDownloader:
    def __init__(self):
        self.ydl_opts = {
            'format': 'bestaudio/best',
            'keepvideo': True,
            'logger': MyLogger(),
            'nocheckcertificate': True,
            'outtmpl': '/data/data/com.example.flutterpython/files/cache/%(id)s.webm',
        }
        self.ydl = youtube_dl.YoutubeDL(self.ydl_opts)
    
    def get_download_path(self, artist, title):
        yt_results = json.loads(YoutubeSearch(artist + ' ' + title, max_results=1).to_json())["videos"]
        id = yt_results[0]["link"].replace('/watch?v=', '')
        return ['/data/data/com.example.flutterpython/files/cache/' + id + ".webm", id]

    
    def stream(self, artist, title):
        yt_results = json.loads(YoutubeSearch(artist + ' ' + title, max_results=1).to_json())["videos"]
        link = 'https://www.youtube.com' + yt_results[0]["link"]
        id = yt_results[0]["link"].replace('/watch?v=', '')
        th = threading.Thread(target=self.ydl.download, args=([link],))
        th.start()
        return '/data/data/com.example.flutterpython/files/cache/' + id + ".webm";


#app.logger.disabled = True
#log = logging.getLogger('werkzeug')
#log.disabled = True

ytd = YouTubeDownloader()

def start():
    #app.run(port=8189, threaded=True)
    ytd.stream('avicii', 'levels')
    try:
        test = os.listdir("/data/data/com.example.flutterpython/files/cache/")
        for file in test:
            return os.path.getsize("/data/data/com.example.flutterpython/files/cache/" + file)
    except Exception as e:
        print(e)

def download(artist, title):
    return ytd.stream(artist, title)

def get_path(artist, title):
    return ytd.get_download_path(artist, title)