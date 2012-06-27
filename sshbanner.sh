#!/bin/bash
echo "running" $0
touch /etc/ssh/sshd-banner
echo $1 > /etc/ssh/sshd-banner

touch /etc/sshd/sshd_config
echo "Banner /etc/ssh/sshd-banner"
