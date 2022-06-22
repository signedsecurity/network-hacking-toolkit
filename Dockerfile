FROM kalilinux/kali-rolling:latest

LABEL org.signedsecurity.image.authors="Alex Munene (enenumxela)"

ARG NHT=/etc/network-hacking-toolkit
ARG HOME=/root
ARG LOCAL_BIN=${HOME}/.local/bin

ARG DEBIAN_FRONTEND=noninteractive

ENV \
	NHT=${NHT} \
	HOME=${HOME} \
	LOCAL_BIN=${LOCAL_BIN}

RUN \
	# up(date|grade)
	apt-get update && \
	apt-get upgrade -qq -y && \
	# create a folder in /etc to store compressed files
	if [ ! -d ${NHT} ];\
	then \
		mkdir -p ${NHT};\
	fi && \
	if [ ! -d ${LOCAL_BIN} ];\
	then \
		mkdir -p ${LOCAL_BIN};\
	fi

# copy the files
COPY scripts.7z ${NHT}/scripts.7z 
COPY configurations.7z ${NHT}/configurations.7z

RUN \
	# install p7zip-full
	apt-get install -y -qq --no-install-recommends \
		p7zip-full && \
	# p7zip extract scripts
	7z x ${NHT}/scripts.7z -o/tmp  && \
	# run setup
	for script in $(find /tmp/scripts -maxdepth 1 -type f -name "*-setup*" -print | sort); \
	do \
		echo ${script}; \
		chmod +x ${script}; \
		${script}; \
	done && \
	# make scrips executable
	chmod +x /tmp/scripts/* && \
	# move scripts to user bin
	mv -f /tmp/scripts/* ${LOCAL_BIN}

WORKDIR $HOME