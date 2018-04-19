#!/bin/bash
# AUTHOR:   Tomas Nevar (tomas@lisenet.com)
# NAME:     puppet-module-build.sh
# VERSION:  1.0
# DATE:     15/09/2016 (dd/mm/yy)
# LICENCE:  Copyleft free software
#
# The location of Puppet modules. This has chanced between
# Puppet 3.x and 4.x, therefore no longer hardcoded.
# You need to specify the path to the modules you want to build.
MOD_DIR=$1;
MANIFEST=""$MOD_DIR"/PULP_MANIFEST";
MANIFEST_BACKUP=""$MOD_DIR"/PULP_MANIFEST.backup";

##
## Sanity checks
##

if [ ! -d "$MOD_DIR" ]; then
  echo "ERROR: module directory does not exist or is not defined.";
  exit 1;
fi
if ! type puppet >/dev/null 2>&1; then
  echo "ERROR: Puppet is not installed.";
  exit 1;
fi

## Backup the current manifest
mv -f "$MANIFEST" "$MANIFEST_BACKUP" 2>/dev/null;

## Puppet module array
MOD_ARRAY="$(ls -d "$MOD_DIR"/*/)";
for module in ${MOD_ARRAY[*]};do

  echo -e "\n$module";
  puppet module build "$module"

  if [ -d "$module"/pkg/ ]; then
    cd "$module"/pkg/;
    MOD_ARCHIVE="$(ls *tar.gz)";

    echo "Copying archive "$MOD_ARCHIVE".";
    cp -f "$MOD_ARCHIVE" ""$MOD_DIR"/";

    echo "Creating manifest "$MANIFEST" entry.";
    echo "$(sha256sum "$MOD_ARCHIVE"|awk '{print $2","$1}')","$(du -b "$MOD_ARCHIVE"|awk '{print $1}')" >>"$MANIFEST";
  else
    echo "ERROR: something went wrong while building '"$module"' module.";
  fi
done

## Restore SELinux context if applicable
if type restorecon >/dev/null 2>&1; then
  echo "Restoring SELinux security context.";
  restorecon -Rv "$MOD_DIR";
fi
