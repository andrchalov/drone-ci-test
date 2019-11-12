#!/bin/sh

REPO=andrchalov/drone-ci-test

latest_release=`
  curl --silent "https://api.github.com/repos/${REPO}/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":' |                                                 # Get tag line
    sed -E 's/.*"([^"]+)".*/\1/'                                         # Pluck JSON value
`

current_release=`cat version`
sha=`cat .git/refs/heads/master`

echo '{"tag":"'${current_release}'","message":"new version","object":"${sha}","type":"commit"}'
echo $GITHUB_API_KEY
if [ $latest_release != $current_release ]
then
  curl -X POST -d '{"tag":"'${current_release}'","message":"new version","object":"'${sha}'","type":"commit"}' --header "Content-Type:application/json" \
    -u andrchalov:$GITHUB_API_KEY "https://api.github.com/repos/${REPO}/git/tags"
fi
