set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

V8_PLATFORM=linux
V8_CPU=ia32

source "$SCRIPT_DIR"/v8-base.sh
