cat << EOF > /etc/systemd/system/shownotif.timer
[Unit]
Description=shownotifs

[Timer]
OnBootSec=1min
OnUnitActiveSec=1min
Persistent=true
OnCalendar=*:0/1

[Install]
WantedBy=timers.target
EOF

cat << EOF > /etc/systemd/system/shownotif.service
[Unit]
Description=Run shownotif script

[Service]
ExecStart=/home/$1/.customscripts/run.sh
Type=simple
User=$1
Environment="DISPLAY=:0"
Environment="DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus"
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now shownotif.timer

if systemctl list-timers --all | grep -q shownotif; then
    bash 
else
    echo "shownotif timer install failed!"
fi
