#!/bin/sh
mysql -u "$MYSQL_APP_USERNAME" --password="$MYSQL_APP_PASSWORD" "$MYSQL_APP_DB"
