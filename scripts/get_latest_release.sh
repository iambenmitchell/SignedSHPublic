#!/bin/bash
getVersion(){
  curl --silent -u gitUserName:Token "https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest" |
  grep '"tag_name":' |
 sed -E 's/.*"([^"]+)".*/\1/'
}
writeVersion(){
  echo "Save Version"
func_result="$(getVersion)"
echo $func_result > version.txt
}

checkForUpdate(){
currentVersion=$(cat version.txt)
latestVersion="$(getVersion)"
if [ "$currentVersion" == "$latestVersion" ]; then
  echo "Strings are equal"
  echo "current version is: "$currentVersion""
  echo "latest version is: "$latestVersion""
else
  echo "Strings are not equal"
  echo "current version is: "$currentVersion""
  echo "latest version is: "$latestVersion""
fi
}

checkForUpdateLive(){
  echo "Checking for updates"
currentVersion=$(cat version.txt)
latestVersion="$(getVersion)"
if [ "$currentVersion" == "$latestVersion" ]; then
  echo "Strings are equal"
  echo "current version is: "$currentVersion""
  echo "latest version is: "$latestVersion""
else
  echo "Strings are not equal"
  echo "current version is: "$currentVersion""
  echo "latest version is: "$latestVersion""
  writeVersion
  downloadURL
fi
}

downloadURL(){
  curl -s https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest \
  | grep "browser_download_url.*ipa" \
  | cut -d : -f 2,3 \
  | tr -d \" \
  | wget -qi -
#removed
  signAll
}

signAll(){
  echo "signing apps"
  #Removed#
tweetUpdate
}

tweetUpdate(){
  echo "Tweet"
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Unc0ver Updated"}' #Webhook Removed
cd /root/
}

go(){
  #!/bin/sh
while [ true ]
do
  dt=$(date '+%d/%m/%Y %H:%M:%S');
  echo "$dt"
cd /root/
pwd
checkForUpdateLive
    sleep 30
done

}






# Check if the function exists (bash specific)
if declare -f "$1" > /dev/null
then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
