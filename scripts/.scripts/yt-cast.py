#!/usr/bin/env python3
# a simple youtube podcast downloader using yt-dlp
# usage: python3 yt_cast.py <youtube url>
# note: python and brew versions have different names
# best when used with `Cliamp` https://github.com/bjarneo/cliamp

import os
import sys
import subprocess

# <<<<<<<< change this
DOWNLOAD_PATH=os.path.expanduser("~/Library/Mobile Documents/com~apple~CloudDocs/Podcasts")
# <<<<<<<<

def default_podcasts_dir():
    path = DOWNLOAD_PATH
    if os.path.isdir(os.path.dirname(path)):
        return path
    return os.path.expanduser("~/Podcasts")

PODCASTS = os.environ.get("PODCASTS_DIR") or default_podcasts_dir()
ARCHIVE = os.path.join(PODCASTS, "download_log.txt")
BITRATE = os.environ.get("YT_CAST_BITRATE", "192")

def get_url():
    if len(sys.argv) > 1:
        return sys.argv[1].strip()
    if not sys.stdin.isatty():
        data = sys.stdin.read().strip()
        if data:
            return data.splitlines()[0].strip()
    return None

def build_cmd(url):
    return [
        "yt-dlp",
        "--format", "bestaudio/best",
        "--no-playlist",
        "--output", os.path.join(PODCASTS, "%(uploader)s - %(title)s.%(ext)s"),
        "--download-archive", ARCHIVE,
        "--retries", "3",
        "--fragment-retries", "3",
        "--extract-audio",
        "--audio-format", "mp3",
        "--audio-quality", BITRATE,
        "--add-metadata",
        url
    ]

def main():
    os.makedirs(PODCASTS, exist_ok=True)
    url = get_url()
    if not url:
        print("usage: python3 yt_cast.py <youtube-url>")
        sys.exit(1)

    print(f"yt-cast: {url}")
    try:
        subprocess.run(build_cmd(url), check=True)
    except subprocess.CalledProcessError as exc:
        print(f"yt-cast: download failed - {exc}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()
