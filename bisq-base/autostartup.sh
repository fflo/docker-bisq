#!/bin/bash

# setup Timezone
if [[ -z "${TZ}" ]]; then
   ln -fs /usr/share/zoneinfo/UTC /etc/localtime
   dpkg-reconfigure -f noninteractive tzdata
else
   ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime
   dpkg-reconfigure -f noninteractive tzdata
fi

# generate
if [ ! -f /etc/xrdp/rsakeys.ini ]
  then
    xrdp-keygen xrdp auto
fi

# setup users
# using the following syntax for /root/createusers.txt
# username:passsword:Y
# username2:password2:Y

file="/root/createusers.txt"
if [ ! -f $file ]
  then
    echo "${BISQ_USER:-bisq}:${BISQ_PASSWORD:-$(dd if=/dev/urandom bs=12 count=1 status=none | base64)}:Y" >> $file
#    if [ ! -e "$BISQ_PASSWORD" ]; then
#      cat $file
#    fi
fi
if [ -f $file ]
  then
    while IFS=: read -r username password is_sudo
      do
        # print out credential(s) to log interface
        echo "Username: $username | Password: $password | Sudo: $is_sudo"

        if getent passwd $username > /dev/null 2>&1
          then
            echo "User Exists"
          else
            useradd -ms /bin/bash $username
            usermod -aG audio $username
            usermod -aG input $username
            usermod -aG video $username
            mkdir -p /run/user/$(id -u $username)/dbus-1/
            chmod -R 700 /run/user/$(id -u $username)/
            chown -R "$username" /run/user/$(id -u $username)/
            echo "$username:$password" | chpasswd
            if [ "$is_sudo" = "Y" ]
              then
                usermod -aG sudo $username
            fi
            if [ "$username" = "bisq" ] || [ "$username" = "$BISQ_USER" ]
              then
                if [ ! -d /home/$username/.local/share/Bisq ]
                  then
                    if [ ! -d /bisq/$username ]
                      then
                        install -d -o $username -g $username -m 700 /bisq/$username
                    fi
                    install -d -o $username -g $username -m 755 /home/$username/.local
                    install -d -o $username -g $username -m 755 /home/$username/.local/share
                    ln -s /bisq/$username /home/$username/.local/share/Bisq
                fi
                if [ -r /usr/share/applications/Bisq.desktop ]
                  then
                    if [ ! -d /home/$username/Desktop ]
                      then
                        install -d -o $username -g $username -m 755 /home/$username/Desktop
                    fi
                    if [ ! -r /home/$username/Desktop/Bisq.desktop ]
                      then
                        install    -o $username -g $username -m 755 \
                                                /dev/null /home/$username/Desktop/Bisq.desktop
                        echo "#!/usr/bin/env xdg-open" >> /home/$username/Desktop/Bisq.desktop
                        cat /usr/share/applications/Bisq.desktop \
                                                       >> /home/$username/Desktop/Bisq.desktop
                    fi
                fi
            fi
        fi
    done <"$file"
fi

startfile="/root/startup.sh"
if [ -f $startfile ]
  then
    sh $startfile
fi

echo "export QT_XKB_CONFIG_ROOT=/usr/share/X11/locale" >> /etc/profile

#This has to be the last command!
/usr/bin/supervisord -n
