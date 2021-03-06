#!/bin/bash

PRODUCT=bluecherry-client
VERSION=$1
GIT_URL=git://github.com/bluecherrydvr/bluecherry-client.git

function usage
{
        echo "Usage: $0 package-version"
        echo "    package-version must be a git tag name"
}

if [ "!" == "!$VERSION" ]; then
        usage
        exit
fi

DEBIAN_PACKAGE_NAME=${PRODUCT}_${VERSION}
DEBIAN_PACKAGE_DIR=${PRODUCT}-${VERSION}
DEBIAN_PACKAGE_FILE=$DEBIAN_PACKAGE_NAME.orig.tar.gz

git clone $GIT_URL $DEBIAN_PACKAGE_DIR
pushd $DEBIAN_PACKAGE_DIR
git checkout $VERSION
git submodule init
git submodule update
find -name ".git*" | xargs rm -rf

cp ../debian.cmake ./user.cmake

debuild --prepend-path /usr/lib/bluecherry/qt4.8/bin -us -uc -sn -b -j5
popd
