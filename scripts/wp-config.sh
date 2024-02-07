#!/bin/bash

source '.environments/.env.db'
source '.environments/.env.wp'

WP_CONFIG_FILE="src/wordpress/wp-config.php"

# declare and associative array to store environment variables
declare -A VARS
VARS+=(["MYSQL_DATABASE"]="$MYSQL_DATABASE" ["MYSQL_USER"]="$MYSQL_USER" ["MYSQL_PASSWORD"]="$MYSQL_PASSWORD" ["WP_DB_HOST"]="$WP_DB_HOST")

# check the requires environment variables before attemting to write file
for key in ${!VARS[@]}; do
  if [ "${VARS[${key}]}" == "" ]; then
    echo -e "\n[WARNING] ${key} is not set"
    echo "Please set ${key} in the correct .environments/.env.* file"
    exit 2
  fi
done

if [ -e "$WP_CONFIG_FILE" ]; then
  #  prompt the user to overwrite the existing wp-config file
  read -rp "$(echo -e "\n[WARNING] $WP_CONFIG_FILE already exists. Do you want to overwrite it? (y/n) ")" -n 1 answer && echo

  if [ "$answer" != "y" ]; then
    # if the user doesn't want to overwrite the existing file, exit
    echo -e "\n[INFO] Exiting..."
    exit 0
  fi
fi

echo -e "\n[INFO] Creating wp-config.php file..."

# using defined variables, write contents to wp-config.php
cat >"$WP_CONFIG_FILE" <<EOL
<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/documentation/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', '$MYSQL_DATABASE' );

/** Database username */
define( 'DB_USER', '$MYSQL_USER' );

/** Database password */
define( 'DB_PASSWORD', '$MYSQL_PASSWORD' );

/** Database hostname */
define( 'DB_HOST', '$WP_DB_HOST' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
\$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/documentation/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
EOL

echo -e "\n[INFO] Successfully created wp-config.php..."
