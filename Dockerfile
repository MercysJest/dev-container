FROM phusion/baseimage:0.11

#RUN apt-get update && apt-get install -y openssh-server
#RUN mkdir /var/run/sshd
#RUN echo 'root:password' | chpasswd
#RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
#RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

#ENV NOTVISIBLE "in users profile"
#RUN echo "export VISIBLE=now" >> /etc/profile

#EXPOSE 22
#CMD ["/usr/sbin/sshd", "-D"]

#Enable ssh
RUN rm -f /etc/service/sshd/down
EXPOSE 22
RUN echo "AllowUsers coder" >> /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication no/PasswordAuthentication no/' /etc/ssh/sshd_config
RUN sed -i 's/#ChallengeResponseAuthentication no/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config

# quietly add a user without password
RUN adduser --quiet --disabled-password --shell /bin/bash --home /home/coder --gecos "User" coder

RUN echo 'coder:tempDSGd43j8k32cna3f4' | chpasswd

# add to sudo group
RUN usermod -aG sudo coder

CMD ["/sbin/my_init"]

RUN apt-get update
RUN install_clean g++ gcc libc6-dev libffi-dev libgmp-dev make xz-utils zlib1g-dev git gnupg netbase
RUN install_clean neovim tmux sudo git haskell-stack haskell-platform wget
RUN apt-get autoremove

RUN mkdir -p /usr/share/terminfo/k
ADD k /usr/share/terminfo/k
RUN chmod 755 /usr/share/terminfo/k
RUN find /usr/share/terminfo/k -exec chmod 755 {} \;

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# lock root
RUN passwd -l root
