#!/bin/bash

platform=$(uname)
if [[ "$platform" == 'Darwin' ]]; then
  hdiutil makehybrid -iso -joliet -default-volume-name config-2 -o iso/configdrive.iso -ov cloud_config
elif [[ "$platform" == 'Linux' ]]; then
  mkisofs -R -V config-2 -o iso/configdrive.iso cloud_config
fi

