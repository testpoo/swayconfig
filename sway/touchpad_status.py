#!/usr/bin/env python3
# coding=utf-8

import os,json

lists = json.load(os.popen("swaymsg -t get_inputs"))
temp = [li for li in lists if li['identifier'] == '2362:597:SYNA3602:00_093A:0255_Touchpad']
status = temp[0]['libinput']['send_events']
if status == "enabled":
    print("开")
else:
    print("关")
