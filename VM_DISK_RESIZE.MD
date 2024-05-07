0. VM in Proxmox resize UBUNTU disk (increase)
1. Load Desktop Ubuntu CD
2. Open GParted
3. Resize /dev/sda3 with all new size
4. Apply changes - Click the "Apply All Operations" button (the green checkmark icon) in the GParted toolbar to execute the changes.
5. Reboot to the server with /dev/sda3
6. Apply changes with commands:

- `sudo lvdisplay` - check logical volumes
- `df -h` - check disk sizes
- `sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv` - extend logical volume (use TAB to autocomplete names)
- `sudo resize2fs /dev/ubuntu-vg/ubuntu-lv` - apply changes (without unmounting)
- `df -h` - validate changes
