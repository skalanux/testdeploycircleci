FROM ubuntu:14.04

RUN apt-get update && apt-get install -y git git-core wget zip zlib1g-dev ruby1.*.*-dev fontforge eot-utils ttfautohint

EXPOSE 80

ENV HOME /root
ADD .bashrc /root/.bashrc

ADD start.sh /tmp/
RUN chmod +x /tmp/start.sh
CMD ./tmp/start.sh
