#!/bin/sh
set -e
cron
exec /usr/sbin/apachectl -DFOREGROUND
