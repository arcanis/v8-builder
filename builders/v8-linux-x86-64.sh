set -ex

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)

VERSION=$1

sudo apt-get install -y \
    pkg-config \
    git \
    subversion \
    curl \
    wget \
    build-essential \
    python \
    xz-utils \
    zip

git config --global user.name "V8 Linux Builder"
git config --global user.email "v8.linux.builder@localhost"
git config --global core.autocrlf false
git config --global core.filemode false
git config --global color.ui true


cd ~
echo "=====[ Getting Depot Tools ]====="	
git clone -q https://chromium.googlesource.com/chromium/tools/depot_tools.git
export PATH=$(pwd)/depot_tools:$PATH
gclient


mkdir v8
cd v8

echo "=====[ Fetching V8 ]====="
fetch v8
echo "target_os = ['linux']" >> .gclient
cd ~/v8/v8
./build/install-build-deps.sh --no-syms --no-nacl --no-prompt
git checkout $VERSION
gclient sync

read -r -d '' V8_FLAGS <<- EOM
target_os = "linux"
$(cat $SCRIPT_DIR/../V8_FLAGS)
EOM

echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py x64.release -vv -- "$V8_FLAGS"
ninja -C out.gn/x64.release -t clean
ninja -C out.gn/x64.release v8_monolith

rsync -rv --include="*/" --include="*.h" --exclude="*" ./include/ out.gn/x64.release/gen/include
ls -Rlh out.gn/x64.release
