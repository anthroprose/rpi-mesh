#!/bin/bash
git pull
sudo chef-solo -c ./chef-repo/config/solo.rb -j ./chef-repo/roles/rpi-mesh.json
