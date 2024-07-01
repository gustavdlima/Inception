#!/bin/bash

# Check if the data directory exists
if [ ! -d "/home/${USER}/data" ]; then
    # Create the data directory and subdirectories
    mkdir ~/data
    mkdir ~/data/mariadb
    mkdir ~/data/wordpress
fi
