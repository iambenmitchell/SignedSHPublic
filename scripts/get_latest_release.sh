#!/bin/bash
getVersion() {
  curl --silent -u username:token "https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}
writeVersion() {
  clear
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

downloadURL() {
  curl -s https://api.github.com/repos/pwn20wndstuff/Undecimus/releases/latest |
    grep "browser_download_url.*ipa" |
    cut -d : -f 2,3 |
    tr -d \" |
    wget -qi -
  rm -rf /path/unc0ver.ipa
  mv *.ipa /path/unc0ver.ipa
  signAll
}

signAll() {
  echo "signing apps"
  cd /root/unsigned/
      #sign script
  tweetUpdate
}

tweetUpdate() {
  echo "Tweet"
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Unc0ver Updated"}' #webhook
  cd /root/
}

go() {
  #!/bin/sh
  while [ true ]; do
    clear
    dt=$(date '+%d/%m/%Y %H:%M:%S')
    echo "$dt"
    cd /root/
    echo "Checking for updates"
    currentVersion=$(cat version.txt)
    latestVersion="$(getVersion)"
    if [ "$currentVersion" == "$latestVersion" ]; then
      echo "$(<image.txt)"
      echo "Already latest version: $latestVersion"
      secs=$((30))
      while [ $secs -gt 0 ]; do
        echo -ne "Next check in: $secs\033[0K\r"
        sleep 1
        : $((secs--))
      done
    else
      echo "current version is: "$currentVersion""
      echo "latest version is: "$latestVersion""
      echo "Updating"
      writeVersion
      downloadURL
    fi
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
      cd /root/unsigned/
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
      rm -rf /paths$fileName.ipa
      mv $fileName.ipa /paths$fileName.ipa
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
