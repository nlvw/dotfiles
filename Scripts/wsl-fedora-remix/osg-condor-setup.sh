#!/bin/bash

sudo dnf install -y https://repo.opensciencegrid.org/osg/3.5/osg-3.5-el7-release-latest.rpm
sudo dnf makecache
sudo dnf install -y htcondor-ce-client

#voms-proxy-init --debug

