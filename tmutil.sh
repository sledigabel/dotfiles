#!/bin/bash


# ONCE SETUP THE TIMEMACHINE DISK

# Exclude all System folders
tmutil addexclusion -p /Applications
tmutil addexclusion -p /Library
tmutil addexclusion -p /System
tmutil addexclusion -p /Users/csadmin
tmutil addexclusion -p /Users/Shared

# Exclude hidden root os folders
tmutil addexclusion -p /bin
tmutil addexclusion -p /cores
tmutil addexclusion -p /etc
tmutil addexclusion -p /Network
tmutil addexclusion -p /private
tmutil addexclusion -p /sbin
tmutil addexclusion -p /tmp
tmutil addexclusion -p /usr
tmutil addexclusion -p /var

# Enable timemachine to start auto backing up
tmutil enable

exit 0
