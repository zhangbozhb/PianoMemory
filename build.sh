#!/bin/sh

cmdType="$1"
configurationName="Release"
if [[ "$1" == "d" || "$1" == "D" || "$1" == "debug" || "$1" == "Debug" ]];then
   configurationName="Debug"
else
    cmdType="$1"
fi

targetName="PianoMemory"
version="1.0"
dateString=`date +%Y_%m_%d_%H_%M`
rootDistributeDirectory="dist"
packageDirectoryName="V${version}_${dateString}"
distributeDirectory="${rootDistributeDirectory}/${packageDirectoryName}"
ipaFileName="${targetName}.ipa"
productName="HairCutSupervisor"
remoteDirectory="/Users/zhangbo/webserver/apacheRootDirectory"
remoteDistributeDirectory="${targetName}/V${version}/${configurationName}"
hostAddress=`ifconfig | grep 'inet' | grep "netmask" | grep -v '127.0.0.1' | cut -d: -f2 | awk '{print $2}'`
urlHost="http://${hostAddress}:80"
logFile="build.log"

if [[ "" == "${configurationName}" || "" == "${targetName}" ]];then
  echo "configurationName and targetName can not be empty"
  exit -1
fi

rootBuildDirectory="build"
buildDirectory="${rootBuildDirectory}/Build/Products/${configurationName}-iphoneos"
buildAppFile="${buildDirectory}/${targetName}.app"
buildAppDsymFile="${buildAppFile}.dSYM"

if [ -d ${rootDistributeDirectory} ];then
  `rm -rf ${rootDistributeDirectory}`
fi
`mkdir -p ${distributeDirectory}`

# clean
echo "*** clean ***"
xcodebuild clean -configuration ${configurationName} >/dev/null 2>&1
`rm -rf ${buildDirectory}`

if [ "${cmdType}" == "clean" ];then
    echo "clean finished"
    exit 0
fi

# xcodebuild -workspace  HairCutSupervisor.xcworkspace -scheme HairCutSupervisor -configuration Release
# build 
echo "*** build package ***"
xcodebuild -configuration ${configurationName} -scheme ${targetName} -workspace  ${targetName}.xcworkspace -derivedDataPath ${rootBuildDirectory} >/dev/null 2>&1
#ipa package
echo "***start package ipa****"
tmpdir="${distributeDirectory}/Payload"
`mkdir -p ${tmpdir}`
`cp -r ${buildAppFile} ${tmpdir} >/dev/null 2>&1`
`cp -r ${buildAppDsymFile} ${distributeDirectory} >/dev/null 2>&1`
pushd ${distributeDirectory} >/dev/null 2>&1
#echo ${distributeDirectory}
#echo "${ipaFileName}"
zip -r "${ipaFileName}" Payload >/dev/null 2>&1
popd >/dev/null 2>&1
rm -rf ${tmpdir}

# generate html file
echo "*** generate html file ***"
cat << EOF > ${distributeDirectory}/index.html
<!DOCTYPE HTML>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>安装此软件</title>
</head>
<body>
<ul>
<li>安装此软件:<a href="itms-services://?action=download-manifest&url=${urlHost}/${remoteDistributeDirectory}/${packageDirectoryName}/${targetName}.plist">${targetName}</a></li>
</ul>
</div>
</body>
</html>

EOF


#generater plits
cat << EOF > ${distributeDirectory}/${targetName}.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>items</key>
    <array>
        <dict>
            <key>assets</key>
            <array>
                <dict>
                    <key>kind</key>
                    <string>software-package</string>
                    <key>url</key>
                    <string>${urlHost}/${remoteDistributeDirectory}/${packageDirectoryName}/${ipaFileName}</string>
                </dict>
                <dict>
                    <key>kind</key>
                    <string>display-image</string>
                    <key>needs-shine</key>
                    <true/>
                    <key>url</key>
                    <string>${urlHost}/icon.png</string>
                </dict>
                <dict>
                    <key>kind</key>
                    <string>full-size-image</string>
                    <key>needs-shine</key>
                    <true/>
                    <key>url</key>
                    <string>${urlHost}/icon.png</string>
                </dict>
            </array>
            <key>metadata</key>
            <dict>
                <key>bundle-identifier</key>
                <string>com.palm4fun.${productName}</string>
                <key>bundle-version</key>
                <string>${version}</string>
                <key>kind</key>
                <string>software</string>
                <key>subtitle</key>
                <string>${productName}</string>
                <key>title</key>
                <string>${productName}</string>
            </dict>
        </dict>
    </array>
</dict>
</plist>


EOF


#copy file to romotedir
if [ -d "${remoteDirectory}" ];then
    mkdir -p "${remoteDirectory}/${remoteDistributeDirectory}" >/dev/null 2>&1
    echo "copy file to remote directory"
    mv ${distributeDirectory} "${remoteDirectory}/${remoteDistributeDirectory}" >/dev/null 2>&1
fi

#clean
rm -rf ${rootBuildDirectory} >/dev/null 2>&1
rm -rf ${rootDistributeDirectory} >/dev/null 2>&1

echo "task finished"

