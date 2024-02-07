#!/bin/bash

source '.environments/.env.db'
source '.environments/.env.wp'

KEY="$(date '+%Y%m%d%H%M%S')"

cat >.config/database-client/config.json <<EOL
// This file is generated temporarily, the configuration is not actually stored here.
{
  "database": {
    "$KEY": {
      "host": "$WP_DB_HOST",
      "port": 3306,
      "user": "$MYSQL_USER",
      "password": "$MYSQL_PASSWORD",
      "dbType": "MySQL",
      "database": "$MYSQL_DATABASE",
      "name": "wordpress",
      "advance": {
        "hideSystemSchema": true
      },
      "timezone": "+00:00",
      "usingSSH": false,
      "useSocksProxy": false,
      "useHTTPProxy": false,
      "global": true,
      "savePassword": "Forever",
      "readonly": false,
      "sort": 11,
      "useSSL": false,
      "dockerConnType": "ssh",
      "fs": {
        "showHidden": true
      },
      "key": "$KEY",
      "connectionKey": "database.connections"
    }
  },
  "nosql": null,
  "$schema": "https://dbclient-release.oss-cn-hongkong.aliyuncs.com/dbclient/schema_new.json"
}
EOL
