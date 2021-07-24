FROM ubuntu:18.04

WORKDIR /home/ubuntu
RUN apt-get update
RUN apt-get install -y sudo git apache2 apt-cacher-ng python-vm-builder ruby qemu-utils lxc
# RUN adduser debian sudo

RUN git clone https://github.com/devrandom/gitian-builder.git
RUN git clone https://github.com/Likli/hcc

RUN printf "service apt-cacher-ng start; \
cd gitian-builder; \
./bin/make-base-vm --lxc --arch amd64 --suite bionic \
./bin/gbuild --num-make 2 --memory 3000 --commit hcc=\$1 \$3" > /home/ubuntu/runit.sh
CMD ["v0.17.0.3","https://github.com/Likli/hcc.git","../hcc/contrib/gitian-descriptors/gitian-osx.yml"]
ENTRYPOINT ["bash", "/home/ubuntu/runit.sh"]
