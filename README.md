# Encoder Handbrake output plugin for Embulk

TODO: Write short description here and embulk-output-encoder_handbrake.gemspec file.

## Overview

* **Plugin type**: output
* **Load all or nothing**: no
* **Resume supported**: no
* **Cleanup supported**: yes

## Configuration

- **command**: handbrake-cli path (string, default: `"/usr/bin/HandBrakeCLI"`)
- **option**: encode option (string, default: `"--all-audio --all-subtitles -O --pfr -E copy:mp3 -B 128 -6 -X 512 -Y 288 --h264-profile baseline --h264-level 3.0 -q 24.0"`)
- **filename**: target-file column-name (string, default: `"filename"`)
- **outputext**: output extension (string, default: `"mp4"`)
- **outputdir**: encoded-file output directory (string, required)
- **successful**: move original file to successful directory if encode successful (string, required)
- **failure**: move original file to failure directory if encode failure (string, required)
- **run**: execute encode if set value (string, default: `""`)
- **limit**: encode limit count (integer, default: `99999`)

## Example

```yaml
out:
  type: encoder_handbrake
  command: "/usr/bin/HandBrakeCLI"
  option: "--all-audio --all-subtitles -O --pfr -E copy:mp3 -B 128 -6 -X 512 -Y 288 --h264-profile baseline --h264-level 3.0 -q 24.0"
  filename: "filename"
  outputext: "mp4"
  outputdir: /home/ubuntu/environment/encode/encoded
  successful: /home/ubuntu/environment/encode/successful 
  failure: /home/ubuntu/environment/encode/fail
  run: "{{ env.RUN }}"
```

## Build

```
$ rake
```
