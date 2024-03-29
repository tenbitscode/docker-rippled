FROM ubuntu:latest

MAINTAINER Jaka Hudoklin <jaka@gatehub.net>

# Official instructions from
# https://ripple.com/build/rippled-setup/#installation-on-ubuntu-with-alien
RUN apt-get update
RUN apt-get install -y yum-utils alien
RUN rpm -Uvh https://mirrors.ripple.com/ripple-repo-el7.rpm
RUN yumdownloader --enablerepo=ripple-stable --releasever=el7 rippled
RUN rpm --import https://mirrors.ripple.com/rpm/RPM-GPG-KEY-ripple-release && rpm -K rippled*.rpm
RUN alien -i --scripts rippled*.rpm && rm rippled*.rpm

COPY ./config/rippled.cfg /etc/opt/ripple/rippled.cfg
COPY ./config/validators.txt /etc/opt/ripple/validators.txt

EXPOSE 80 443 5005 6006 51235

ENTRYPOINT ["/opt/ripple/bin/rippled"]
CMD ['--net', '--conf', '/etc/opt/ripple/rippled.cfg']
