#!/usr/bin/env bash
set -euo pipefail

if [ -d .peerlink-import ]; then
  cat .peerlink-import/*.b64 | base64 --decode > /tmp/peerlink-source.tar.xz
  mkdir -p /tmp/peerlink-source
  tar -xJf /tmp/peerlink-source.tar.xz -C /tmp/peerlink-source
  test -f /tmp/peerlink-source/peerlink/package.json
  cp -a /tmp/peerlink-source/peerlink/. .
  rm -rf peerlink .peerlink-import
fi

sed -i 's/left?: string }/left?: string; membership?: string }/' 'src/app/communities/[slug]/page.tsx'
sed -i 's/community\.campuses?.name/community.campuses?.[0]?.name/g; s/community\.campuses?.city/community.campuses?.[0]?.city/g; s/community\.profiles?.display_name/community.profiles?.[0]?.display_name/g; s/member\.profiles?.display_name/member.profiles?.[0]?.display_name/g; s/member\.profiles?.username/member.profiles?.[0]?.username/g' 'src/app/communities/[slug]/page.tsx'
sed -i 's/event\.campuses?.name/event.campuses?.[0]?.name/g; s/event\.campuses\.name/event.campuses[0].name/g; s/event\.profiles?.display_name/event.profiles?.[0]?.display_name/g; s/event\.communities?.slug/event.communities?.[0]?.slug/g; s/event\.communities\.slug/event.communities[0].slug/g; s/event\.communities\.title/event.communities[0].title/g' 'src/app/events/[slug]/page.tsx'
sed -i 's/conversation\.listings?.title/conversation.listings?.[0]?.title/g' 'src/app/messages/[id]/page.tsx'
sed -i 's/profile\.campuses?.name/profile.campuses?.[0]?.name/g; s/profile\.campuses\.name/profile.campuses[0].name/g' 'src/app/profile/[username]/page.tsx'
sed -i 's/request\.campuses?.name/request.campuses?.[0]?.name/g' 'src/app/verify/page.tsx'
sed -i 's/purpose: "any maskable"/purpose: "any"/g' src/app/manifest.ts

if [ "${PEERLINK_SKIP_INSTALL:-0}" != "1" ]; then
  npm install
fi
