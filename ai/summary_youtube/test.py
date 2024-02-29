import whisper
model = whisper.load_model("base")
result = model.transcribe("transformers.wav")
print(f' The text in video: \n {result["text"]}')