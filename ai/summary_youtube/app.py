from langchain.document_loaders.blob_loaders.youtube_audio import YoutubeAudioLoader
import whisper

# set a flag to switch between local and remote parsing
# change this to True if you want to use local parsing
local = True

# Two Karpathy lecture videos
urls = ["https://youtu.be/kCc8FmEb1nY", "https://youtu.be/VMj-3S1tku0"]

# Directory to save audio files
save_dir = "/home/daf/Downloads"

loader = YoutubeAudioLoader(urls, save_dir)
loader.yield_blobs()
