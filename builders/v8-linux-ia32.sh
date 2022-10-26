set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

V8_PLATFORM=linux
V8_CPU=ia32

sudo apt-get install -y \
    lib32stdc++6

source "$SCRIPT_DIR"/v8-base.sh
