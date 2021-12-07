import tempfix
import os
import json
import tempfile
import youtube_dl
from youtube_search import YoutubeSearch

class MyLogger(object):
	def debug(self, msg):
		pass
	def warning(self, msg):
		pass
	def error(self, msg):
		pass

class YouTubeDownloader:
	def __init__(self):
		self.ydl_opts = {
			'format': 'bestaudio/best',
			'keepvideo': False,
			'logger': MyLogger(),
			'nocheckcertificate': True,
			'preferredcodec': 'mp3',
			'outtmpl': tempfix.FIX_TEMPPATH + "/music/" + '%(id)s',
		}
		self.ydl = youtube_dl.YoutubeDL(self.ydl_opts)
	
	def get_download_path(self, artist, title):
		yt_results = json.loads(YoutubeSearch(artist + ' ' + title, max_results=1).to_json())["videos"]
		id = yt_results[0]["link"].replace('/watch?v=', '')
		return [tempfix.FIX_TEMPPATH + "/music/" + id, id]

	
	def download(self, artist, title):
		yt_results = json.loads(YoutubeSearch(artist + ' ' + title, max_results=1).to_json())["videos"]
		link = 'https://www.youtube.com' + yt_results[0]["link"]
		id = yt_results[0]["link"].replace('/watch?v=', '')
		self.ydl.download([link])
		return tempfix.FIX_TEMPPATH + "/music/" + id
	
	def downloadId(self, id):
		link = 'https://www.youtube.com/watch?v=' + id
		self.ydl.download([link])
		return tempfix.FIX_TEMPPATH + "/music/" + id

ytd = None
def init(tempPath):
	tempfix.FIX_TEMPPATH = tempPath
	import os
	import json
	import tempfile
	import youtube_dl
	from youtube_search import YoutubeSearch
	try:
		os.makedirs(tempfix.FIX_TEMPPATH + "/music/")
		print('[PYTHON36] Success, Temp folder was created.')
	except:
		print('[PYTHON36] Couldnt create new temp folder, maybe it already exists')
	global ytd
	ytd = YouTubeDownloader()

def downloadId(id):
	return ytd.downloadId(id)