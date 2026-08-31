#!/bin/bash -e
if hash docker 2>/dev/null; then
  echo "Docker aleady installed"
else
  sudo apt-get update -y -o Acquire::http::Timeout="240" -o Acquire::https::Timeout="240"
  sudo apt install docker.io -y  
fi
