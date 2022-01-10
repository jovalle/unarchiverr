# unarchiverr

Bash script for auto detecting rar files in a specific path (recursively with `find`) and extract contents accordingly.

## Installation

`setup.sh` will:
* create symlink at `/usr/local/bin/unarchiverr`
* ensure a cronjob runs script every minute
* verbose logs are written to `/var/log/syslog` using `logger`

### Example
```bash
bash setup.sh /downloads
```
