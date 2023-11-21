FROM ubuntu:latest


RUN apt update
RUN apt install -y openssh-server
RUN apt install -y openssh-sftp-server
RUN apt install -y xinetd telnetd
RUN apt install -y telnet
RUN apt install -y net-tools
RUN apt install -y tcpdump

# telnet 설정

RUN echo "service telnet\n{\ndisable = no\nflags = REUSE\nsocket_type = stream\nwait = no\nuser = root\nserver = /usr/sbin/in.telnetd\nlog_on_failure += USERID\n}" > /etc/xinetd.d/telnet

# `service xinetd restart` 명령 실행을 위해서는 언어 설정이 필요하다.
RUN apt install -y language-pack-ko

ENV LC_ALL=C.utf8
ENV LANG=C.utf8

# "systemctl restart xinetd"을 다음의 명령으로 대체함.
RUN service xinetd restart
RUN service ssh start


# ssh로 접속할 수 있도록 루트 사용자의 비밀번호를 'pw'로 변경.
RUN echo 'root:pw' | chpasswd

# ssh에 루트 사용자로 접속할 수 있도록 ssh 설정 변경
RUN sed -i '/#PermitRootLogin prohibit-password/PermitRootLogin yes' /etc/ssh/sshd_config
RUN service ssh restart

# SSH에 사용되는 22번 포트를 외부로 공개 선언
EXPOSE 22
