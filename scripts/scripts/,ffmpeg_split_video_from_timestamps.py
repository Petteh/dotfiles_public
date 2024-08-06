#!/usr/bin/env python3

from os.path import exists, splitext, basename

import subprocess
import argparse

DEFAULT_TIMESTAMPS_FILE = ".timestamps.txt"


def read_file(filename: str) -> str:
    with open(filename, "r", encoding="utf-8") as f:
        return f.read()


def sec2ts(seconds: float) -> str:
    mm, ss = divmod(int(seconds), 60)
    hh, mm = divmod(mm, 60)
    return f"{hh:02d}{mm:02d}{ss:02d}"


FSM_LOOKING = 0
FSM_FOUND = 1


def parse_timestamps(vid: str, timestamps_all: str) -> list:
    vid_timestamps: list = []
    timestamps: list = []
    fsm = FSM_LOOKING
    for line in timestamps_all.split("\n"):
        if fsm == FSM_LOOKING:
            if basename(vid) in line:
                fsm = FSM_FOUND
                timestamps = []
        elif fsm == FSM_FOUND:
            if line == "":
                fsm = FSM_LOOKING
                vid_timestamps.append(timestamps)
            else:
                start, stop = line.strip().split()
                timestamps.append((start, stop))

    # Select the most recent entry
    if not vid_timestamps:
        print(f"[WARNING] '{vid}' has no entries in timestamps file")
        return []
    elif len(vid_timestamps) > 1:
        print(
            f"[WARNING] '{vid}' has multiple entries in timestamps file. Picking latest"
        )

    return vid_timestamps[-1]


def split_video(vid_path: str, start: float, stop: float):
    if not exists(vid_path):
        print(f"[ERROR] File '{vid_path}' does not exist. Skipping...")
        return

    name, ext = splitext(vid_path)
    split_path = f"{name}_splits_{sec2ts(start)}-{sec2ts(stop)}{ext}"

    cmd = [
        "ffmpeg",
        "-nostdin",
        "-y",
        "-loglevel",
        "error",
        "-ss",
        str(start),
        "-t",
        str(stop - start),
        "-i",
        vid_path,
        "-map",
        "0",
        "-c:v",
        "copy",
        "-c:a",
        "copy",
        "-c:s",
        "copy",
        "-avoid_negative_ts",
        "make_zero",
        split_path,
    ]
    print(f"[INFO] Running cmd: {' '.join(cmd)}")
    subprocess.run(cmd, encoding="utf-8", check=True)


def main(vids: list, timestamps_file: str):
    if not timestamps_file:
        timestamps_file = DEFAULT_TIMESTAMPS_FILE

    timestamps_all = read_file(timestamps_file)

    for vid in vids:
        timestamps = parse_timestamps(vid, timestamps_all)
        for start, stop in timestamps:
            split_video(vid, float(start), float(stop))


# If run as a script, parse arguments from command line
if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Split videos based on timestamps file"
    )
    parser.add_argument(
        dest="vids",
        type=str,
        nargs="+",
        help="Videos that should be split",
    )
    parser.add_argument(
        "-t",
        "--timestamps",
        dest="timestamps_file",
        type=str,
        help="Timestamps file",
    )

    args = parser.parse_args()
    main(**vars(args))
