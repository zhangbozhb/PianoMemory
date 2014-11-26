#!/bin/sh

cmdType="$1"
configurationName="Release"
if [[ "$1" == "d" || "$1" == "D" || "$1" == "debug" || "$1" == "Debug" ]];then
   configurationName="Debug"
else
    cmdType="$1"
fi

targetName="PianoMemory"
plistFile="${targetName}/Info.plist"
version=`/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${plistFile}"`
#version="1.1.1"
dateString=`date +%Y_%m_%d_%H_%M`
rootDistributeDirectory="dist"
packageDirectoryName="V${version}_${dateString}"
distributeDirectory="${rootDistributeDirectory}/${packageDirectoryName}"
ipaFileName="V${version}_${dateString}.ipa"
remoteDirectory="/Users/zhangbo/webserver/apacheRootDirectory"
remoteDistributeDirectory="${targetName}/V${version}/${configurationName}"
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

# change build version
buildVersion=`/usr/libexec/PlistBuddy -c "Print CFBundleVersion" ${plistFile}`
startDateTimestamp=`date -j -f "%Y-%m-%d" 2014-10-01 "+%s"`
currentTimestamp=`date +%s`
diffTimestamp=$(($currentTimestamp-$startDateTimestamp))
diffHour=$(($diffTimestamp/3600/24))
buildVersion=$diffHour
#buildVersion=$(($buildVersion + 1))
`/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildVersion" "${plistFile}"`

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

