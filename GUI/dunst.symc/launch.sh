#!/usr/bin/env bash

pidof dunst && killall dunst
dunst &
