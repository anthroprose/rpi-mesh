#!/bin/bash
git pull
sudo chef-solo -c ~/rpi-mesh/chef-repo/config/solo.rb -j ~/rpi-mesh/chef-repo/roles/rpi-mesh.json
