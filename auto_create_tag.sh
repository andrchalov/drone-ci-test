#!/bin/sh

current_release=`cat version`

tag_page_status=`curl -s -o /dev/null -w "%{http_code}" https://github.com/andrchalov/drone-ci-test/releases/tag/${current_release}`

if [ $tag_page_status == "404" ]
then
  sha=`cat .git/refs/heads/master`

  echo '{"tag":"'${current_release}'","message":"new version","object":"${sha}","type":"commit"}'

  curl -X POST -d '{"tag":"'${current_release}'","message":"new version","object":"'${sha}'","type":"tree"}' \
    --header "Content-Type:application/json" \
    -u andrchalov:$GITHUB_API_KEY \
    "https://api.github.com/repos/${DRONE_REPO}/git/tags"

  curl -X POST -d '{"ref":"refs/tags/'${current_release}'","sha":"'${sha}'"' \
    --header "Content-Type:application/json" \
    -u andrchalov:$GITHUB_API_KEY "https://api.github.com/repos/${DRONE_REPO}/git/refs"
fi
