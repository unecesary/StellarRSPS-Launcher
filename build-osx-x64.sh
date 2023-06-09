#!/bin/bash

set -e

JDK_VER="11.0.16.1"
JDK_BUILD="1"
JDK_HASH="10be61a8dd3766f7c12e2e823a6eca48cc6361d97e1b76310c752bd39770c7fe"
PACKR_VERSION="runelite-1.4"

SIGNING_IDENTITY="Developer ID Application"

if ! [ -f OpenJDK11U-jre_x64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz ] ; then
    curl -Lo OpenJDK11U-jre_x64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz \
        https://github.com/adoptium/temurin11-binaries/releases/download/jdk-${JDK_VER}%2B${JDK_BUILD}/OpenJDK11U-jre_x64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz
fi

echo "${JDK_HASH}  OpenJDK11U-jre_x64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz" | shasum -c

# packr requires a "jdk" and pulls the jre from it - so we have to place it inside
# the jdk folder at jre/
if ! [ -d osx-jdk ] ; then
    tar zxf OpenJDK11U-jre_x64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz
    mkdir osx-jdk
    mv jdk-${JDK_VER}+${JDK_BUILD}-jre osx-jdk/jre

    pushd osx-jdk/jre
    # Move JRE out of Contents/Home/
    mv Contents/Home/* .
    # Remove unused leftover folders
    rm -rf Contents
    popd
fi

if ! [ -f packr_${PACKR_VERSION}.jar ] ; then
    curl -Lo packr_${PACKR_VERSION}.jar \
        https://github.com/runelite/packr/releases/download/${PACKR_VERSION}/packr.jar
fi

echo "f51577b005a51331b822a18122ce08fca58cf6fee91f071d5a16354815bbe1e3  packr_${PACKR_VERSION}.jar" | shasum -c

java -jar packr_${PACKR_VERSION}.jar \
    packr/macos-x64-config.json

cp target/filtered-resources/Info.plist native-osx/SarinRSPS.app/Contents

echo Setting world execute permissions on SarinRSPS
pushd native-osx/SarinRSPS.app
chmod g+x,o+x Contents/MacOS/SarinRSPS
popd

codesign -f -s "${SIGNING_IDENTITY}" --entitlements osx/signing.entitlements --options runtime native-osx/SarinRSPS.app || true

# create-dmg exits with an error code due to no code signing, but is still okay
# note we use Adam-/create-dmg as upstream does not support UDBZ
create-dmg --format UDBZ native-osx/SarinRSPS.app native-osx/ || true

mv native-osx/SarinRSPS\ *.dmg native-osx/SarinRSPS-x64.dmg

if ! hdiutil imageinfo native-osx/SarinRSPS-x64.dmg | grep -q "Format: UDBZ" ; then
    echo "Format of resulting dmg was not UDBZ, make sure your create-dmg has support for --format"
    exit 1
fi

# Notarize app
if xcrun notarytool submit native-osx/SarinRSPS-x64.dmg --wait --keychain-profile "AC_PASSWORD" ; then
    xcrun stapler staple native-osx/SarinRSPS-x64.dmg
fi
