#!/bin/bash

set -e

JDK_VER="17.0.4.1"
JDK_BUILD="1"
JDK_HASH="63a32fe611f2666856e84b79305eb80609de229bbce4f13991b961797aa88bf8"
PACKR_VERSION="runelite-1.4"

SIGNING_IDENTITY="Developer ID Application"

FILE="OpenJDK17U-jre_aarch64_mac_hotspot_${JDK_VER}_${JDK_BUILD}.tar.gz"
URL="https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JDK_VER}%2B${JDK_BUILD}/${FILE}"

if ! [ -f ${FILE} ] ; then
    curl -Lo ${FILE} ${URL}
fi

echo "${JDK_HASH}  ${FILE}" | shasum -c

# packr requires a "jdk" and pulls the jre from it - so we have to place it inside
# the jdk folder at jre/
if ! [ -d osx-aarch64-jdk ] ; then
    tar zxf ${FILE}
    mkdir osx-aarch64-jdk
    mv jdk-${JDK_VER}+${JDK_BUILD}-jre osx-aarch64-jdk/jre

    pushd osx-aarch64-jdk/jre
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
	packr/macos-aarch64-config.json

cp target/filtered-resources/Info.plist native-osx-aarch64/SarinRSPS.app/Contents

echo Setting world execute permissions on SarinRSPS
pushd native-osx-aarch64/SarinRSPS.app
chmod g+x,o+x Contents/MacOS/SarinRSPS
popd

codesign -f -s "${SIGNING_IDENTITY}" --entitlements osx/signing.entitlements --options runtime native-osx-aarch64/SarinRSPS.app || true

# create-dmg exits with an error code due to no code signing, but is still okay
create-dmg native-osx-aarch64/SarinRSPS.app native-osx-aarch64/ || true

mv native-osx-aarch64/SarinRSPS\ *.dmg native-osx-aarch64/SarinRSPS-aarch64.dmg

# Notarize app
if xcrun notarytool submit native-osx-aarch64/SarinRSPS-aarch64.dmg --wait --keychain-profile "AC_PASSWORD" ; then
    xcrun stapler staple native-osx-aarch64/SarinRSPS-aarch64.dmg
fi
