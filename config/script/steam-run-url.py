import os
from pathlib import Path
import subprocess

pipe_path = Path(f'/run/user/{os.getuid()}/steam-run-url.fifo')
try:
    pipe_path.parent.mkdir(parents=True, exist_ok=True)
    pipe_path.unlink(missing_ok=True)
    os.mkfifo(pipe_path, 0o600)
    while True:
        with pipe_path.open(encoding='utf-8') as pipe:
            subprocess.Popen(['steam', pipe.read().strip()])
finally:
    pipe_path.unlink(missing_ok=True)
