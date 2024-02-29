from pytube import YouTube

def download_video_youtube(url, output_path="."):
    try:
        # Create a YouTube object
        yt = YouTube(url)

        # Get the highest resolution stream
        video_stream = yt.streams.get_highest_resolution()

        # Set the output path and download the video
        video_stream.download(output_path)

        print(f"Video downloaded successfully to {output_path}")
    except Exception as e:
        print(f"Error: {e}")

def download_video(url, output_path="."):
    try:
        # Create a YouTube object
        yt = YouTube(url)

        # Get the highest resolution stream
        video_stream = yt.streams.get_highest_resolution()

        # Set the output path and download the video
        video_stream.download(output_path)

        print(f"Video downloaded successfully to {output_path}")
    except Exception as e:
        print(f"Error: {e}")

# Example usage
video_url = "https://www.youtube.com/shorts/2hG2i0_EKTg"
output_directory = "."
#download_video (video_url)
download_video_youtube(video_url)