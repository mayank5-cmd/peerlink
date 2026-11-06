#!/usr/bin/env bash
set -euo pipefail

# The Git bootstrap commit contains a compressed source archive split into
# text-safe base64 chunks. Restore it before Vercel runs npm install.
if [ -d .peerlink-import ]; then
  cat .peerlink-import/*.b64 | base64 --decode > /tmp/peerlink-source.tar.xz
  mkdir -p /tmp/peerlink-source
  tar -xJf /tmp/peerlink-source.tar.xz -C /tmp/peerlink-source
  test -f /tmp/peerlink-source/peerlink/package.json
  cp -a /tmp/peerlink-source/peerlink/. .
  rm -rf peerlink .peerlink-import
fi

npm install
