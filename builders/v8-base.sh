VERSION=$1

if [[ $V8_PLATFORM == linux ]]; then
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
fi

git config --global user.name "V8 Builder"
git config --global user.email "v8.builder@localhost"
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
echo "target_os = ['$V8_PLATFORM']" >> .gclient
cd ~/v8/v8
git checkout $VERSION
gclient sync

read -r -d '' V8_FLAGS <<- EOM || true
target_os = "${V8_PLATFORM}"
$(cat $SCRIPT_DIR/../V8_FLAGS)
EOM

echo "=====[ Building V8 ]====="
python ./tools/dev/v8gen.py gen -vv -b "$V8_CPU".release build -- "$V8_FLAGS"
ninja -C out.gn/build -t clean
ninja -C out.gn/build v8_monolith

rsync -rv --include="*/" --include="*.h" --exclude="*" ./include/ out.gn/build/gen/include
ls -Rlh out.gn/build

mkdir out.gn/out

mv out.gn/build/obj/libv8_monolith.a out.gn/out/
mv out.gn/build/gen/include out.gn/out/
