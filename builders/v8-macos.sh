set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

V8_PLATFORM=mac
V8_CPU=x64

source "$SCRIPT_DIR"/v8-base.sh
