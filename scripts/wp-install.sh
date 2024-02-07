#!/bin/bash

source '.environments/.env.wp'

WP_URL="https://wordpress.org"
WP_FILE="wordpress-$WP_VERSION.tar.gz"
WP_DIR="src/wordpress"

function do_setup {
  if [ $WP_VERSION == "" ]; then
    echo -e "\n[WARNING] WP_VERSION is not set"
    echo "Please set WP_VERSION in the .environments/.env.wp file"
    exit 2
  fi
}

function do_destroy {
  echo -e "\n[INFO] Removing $WP_FILE..."
  rm -rf "$WP_FILE"
}

function create_dir {
  if [ ! -d "$1" ]; then
    mkdir -p "$1"
  fi
}

function validate_checksum {
  echo -e "\n[INFO] Validating checksums..."
  # request the checksum from wordpress.org and check it againt the file
  echo -n "$(curl -s "$WP_URL/$WP_FILE.sha1") $WP_FILE" | sha1sum -c 2>/dev/null | grep -q "OK" &>/dev/null

  if [ $? == 0 ]; then
    echo -e "\n[INFO] Checksums matched" && install_wordpress
  else
    #  if the checksums didn't match
    echo -e "\n[ERROR] Checksums do not match"
    # remove the file and reinstall
    echo -e "\n[INFO] Removing exiting $WP_FILE..."
    do_destroy &&
      do_install
  fi
}

function get_wordpress {
  # silently download the wordpress file
  curl -s -o "$WP_FILE" "$WP_URL/$WP_FILE"
}

function expand_archive {
  echo -e "\n[INFO] Expanding $WP_FILE into $WP_DIR..."
  # create the src/wordpress directory and expand the arcive into it
  create_dir "$WP_DIR" &&
    tar -xzf "$WP_FILE" -C "$(dirname $WP_DIR)" &&
    echo -e "\n[INFO] Successfully expanded $WP_FILE to $WP_DIR"

}

function install_wordpress {
  # check if there is an existing WordPress installation
  if [ ! -d "$WP_DIR" ]; then
    expand_archive
  else
    #  prompt the user to overwrite the existing installation
    read -rp "$(echo -e "\n[WARNING] $WP_DIR already exists. Do you want to overwrite it? (y/n) ")" -n 1 answer && echo

    if [ "$answer" != "y" ]; then
      # if the user doesn't want to overwrite the existing installation, exit
      echo -e "\n[INFO] Exiting..."
      exit 0
    else
      #  otherwise, remove the existing installation and expand the archive
      rm -rf $WP_DIR &&
        expand_archive
    fi
  fi
}

function do_install {
  do_setup
  # check if the WordPress archive already exists
  if [ ! -f "$WP_FILE" ]; then
    echo -e "[INFO] Downloading WordPress..."
    get_wordpress &&
      validate_checksum
  else
    echo -e "\n[INFO] $WP_FILE already exists" &&
      validate_checksum
  fi
  do_destroy
  echo -e "\n[INFO] WordPress installation complete"

}

function post_install {
  # run the script to create the wp-config.php file
  ./scripts/wp-config.sh
}

do_install &&
  post_install
