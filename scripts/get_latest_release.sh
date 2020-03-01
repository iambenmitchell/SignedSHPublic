#!/bin/bash
getVersion() {
  curl --silent -u username:token "https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}
writeVersion() {
  echo "Save Version"
  func_result="$(getVersion)"
  echo $func_result >version.txt
}

checkForUpdate() {
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

checkForUpdateLive() {
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

downloadURL() {
  curl -s https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest |
    grep "browser_download_url.*ipa" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
  rm -rf #file#
  mv *.ipa #new#
  signAll
}

signAll() {
  #signscript
  tweetUpdate
}

tweetUpdate() {
  echo "Tweet"
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Unc0ver Updated"}' #webhook#
  cd /root/
}

go() {
  #!/bin/sh
  while [ true ]; do
    dt=$(date '+%d/%m/%Y %H:%M:%S')
    echo "$dt"
    cd /root/
    pwd
    checkForUpdateLive
    sleep 30
  done

}
manager() {
  cd /root/
  echo "$(<image.txt)"
  PS3='Please enter your choice: '
  options=("Watchdog" "Send tweet" "Manual Sign" "Download App" "Manual Sign All" "Quit")
  select opt in "${options[@]}"; do
    case $opt in
    "Watchdog")
      go
      ;;
    "Send tweet")
      clear
      echo "What do you want to tweet, Ben?"
      read tweetText
      curl -X POST -H 'Content-type: application/json' --data '{"text":"'$tweetText'"}' #webhook
      clear
      manager
      ;;
    "Manual Sign")
      clear
      echo "Signing app manually, must be in unsigned folder"
      echo "What is the name of the IPA, eg unc0ver.ipa"
      read ipaName
      #sign script
      echo "Done"
      manager
      ;;
    "Download App")
      echo "Downloading app"
      echo "What should we call it?"
      read fileName
      echo "What is the link?"
      read linkDownload
      cd /root/downloads
      wget -O $fileName.ipa $linkDownload
      rm -rf /path/$fileName.ipa
      mv $fileName.ipa /path/$fileName.ipa
      rm -rf $fileName.ipa
      clear
      manager
      ;;
    "Manual Sign All")
      clear
      echo "Signing all apps"
      #sign script
      clear
      manager
      ;;
    "Quit")
      clear
      exit 1
      ;;
    *) echo "invalid option $REPLY" ;;
    esac
  done
}
# Check if the function exists (bash specific)
if declare -f "$1" >/dev/null; then
  # call arguments verbatim
  "$@"
else
  # Show a helpful error
  echo "'$1' is not a known function name" >&2
  exit 1
fi
