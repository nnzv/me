setxkbmap latam
xrandr -s 1920x1080
pipewire &
redshift &
nitrogen --set-tiled --random ~/.local/jpg
exec dbus-launch --sh-syntax --exit-with-session awesome
