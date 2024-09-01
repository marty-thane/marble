# Disable GRUB timeout
if grep -q "^GRUB_TIMEOUT=" /etc/default/grub; then
	sed -i -E 's/GRUB_TIMEOUT=[0-9]*/GRUB_TIMEOUT=0/' /etc/default/grub
else
	echo "GRUB_TIMEOUT=0" >> /etc/default/grub
fi
grub-mkconfig -o /boot/grub/grub.cfg
