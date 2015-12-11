#!/bin/bash

# Disable Strict Host checking for non interactive git clones


# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
