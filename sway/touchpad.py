#!/usr/bin/env python3
# coding=utf-8

import os,json

status = json.load(os.popen("swaymsg -t get_inputs"))[4]['libinput']['send_events']
if status == "enabled":
	os.system("swaymsg input \"2362:597:SYNA3602:00_093A:0255_Touchpad\" events disabled")
else:
    os.system("swaymsg input \"2362:597:SYNA3602:00_093A:0255_Touchpad\" events enabled")
