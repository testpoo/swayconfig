#!/bin/bash

# 启用JSON协议头
echo '{"version":1,"click_events":false}'
echo '[' # 开始JSON数组
echo '[]' # 初始化空数组

# 主循环生成状态信息
while true; do
  # 获取动态数据
  # 时间
  now_time=$(date '+%A %F %H:%M 第%V周')

  # 电量
  battary="⚡️"$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "percentage\|time to empty" | awk -F ':' '{print $2,$4}' | sed 's/ //g') 
  # battary="ϟ "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "state\|percentage\|time to empty" | awk -F ':' '{print $2,$4}' | sed 's/ //g') 

  # 亮度
  light="🔆"$(brightnessctl get | awk '{print $1/192"%"}')

  # 声音
  volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '{print $2}' | sed 's/ //g')
  if [ $(pactl get-sink-mute @DEFAULT_SINK@ | awk -F ' ' '{print $2}') = "否" ];then volume="🔊"$volume;else volume="🔇"$volume;fi

  # CPU
  cpuUsage="©️"$(top -b -n1 | fgrep "Cpu" | awk '{printf "%d", 100-$8}')"%"

  # 内存
  mem_used_persent="Ⓜ️"$(free -m | fgrep "内存" | awk '{printf "%.1f",$3/1024}')"G"

  # 磁盘
  diskUsage="💾"$(df -h | fgrep "/dev/sda2" | awk '{print $3}')

  # 网络
  if [ $(hostname -I | awk -F ' ' '{print $1}' | cut -d '.' -f 1-2) = "192.168" ];then network="📶连接";else network="🌐断开";fi

  # 触摸板
  touchpad="📋"$(swaymsg -t get_inputs | python3 -c "import sys,json; print(json.load(sys.stdin)[4]['libinput']['send_events'])" | awk -F : '{if ($0 == "enabled"){print "开"} else {print "关"}}')

  # 构造带点击标识的JSON块
  JSON_BLOCKS=$(cat <<EOF
,[
  {"full_text":"$touchpad","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$cpuUsage","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$mem_used_persent","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$diskUsage","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$light","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$volume","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$network","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$battary","min_width": 50,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"},
  {"full_text":"$now_time","min_width": 200,"align":"center","background":"#111111aa","separator":false,"separator_block_width":3,"color":"#ffffff"}
]
EOF
  )

  echo "$JSON_BLOCKS"  
  sleep 1
done