# 时间
now_time=$(date '+%A %F %H:%M 第%V周')

# 电量
battary="ϟ "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "percentage\|time to empty" | awk -F ':' '{print $2,$4}' | sed 's/ //g') 
# battary="ϟ "$(upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep -i "state\|percentage\|time to empty" | awk -F ':' '{print $2,$4}' | sed 's/ //g') 

# 亮度
light="☀ "$(brightnessctl get | awk '{print $1/192"%"}')

# 声音
mute=$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F ' ' '{print $2}')
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F '/' '{print $2}' | sed 's/ //g')
if [ $mute = "否" ];then
    volume="♪ "$volume
else
    volume="Ø "$volume
fi

# CPU
cpuUsage="Ⓒ "$(top -b -n1 | fgrep "Cpu" | awk '{printf "%d", 100-$8}')"%"

# 内存
mem_used_persent="Ⓜ "$(free -m | fgrep "内存" | awk '{printf "%.1f",$3/1024}')"G"

# 磁盘
diskUsage="☰ "$(df -h | fgrep "/dev/sda2" | awk '{print $3}')

# 网络
network="▦ "$(hostname -I | awk -F ' ' '{print $1}')

# 触摸板
touchpad="▣ "$(swaymsg -t get_inputs | python3 -c "import sys,json; print(json.load(sys.stdin)[4]['libinput']['send_events'])" | awk -F : '{if ($0 == "enabled"){print "开"} else {print "关"}}')

# bar输出
echo $touchpad"丨"$cpuUsage"丨"$mem_used_persent"丨"$diskUsage"丨"$light"丨"$volume"丨"$network"丨"$battary"丨"$now_time
