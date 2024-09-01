# Enable NumLock at boot
mkdir -pv "/etc/sv/numlock"
cp -v "$STATIC_DIR/numlock" "/etc/sv/numlock/run"
chmod +x /etc/sv/numlock/run
service_enable numlock
