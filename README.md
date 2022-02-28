<h1 align="center">Network Hacking ToolKit</h1>

<p align="center">
	<a href="https://github.com/signedsecurity/network-hacking-toolkit/actions">
		<img alt="GitHub Workflow Status" src="https://img.shields.io/github/workflow/status/signedsecurity/network-hacking-toolkit/🎉%20CI%20to%20Docker%20Hub">
	</a>
	<a href="https://github.com/signedsecurity/network-hacking-toolkit/issues?q=is:issue+is:open">
		<img alt="GitHub Open Issues" src="https://img.shields.io/github/issues-raw/signedsecurity/network-hacking-toolkit.svg">
	</a>
	<a href="https://github.com/signedsecurity/network-hacking-toolkit/issues?q=is:issue+is:closed">
		<img alt="GitHub Closed Issues" src="https://img.shields.io/github/issues-closed-raw/signedsecurity/network-hacking-toolkit.svg">
	</a>
	<a href="https://github.com/signedsecurity/network-hacking-toolkit/graphs/contributors">
		<img alt="GitHub contributors" src="https://img.shields.io/github/contributors/signedsecurity/network-hacking-toolkit">
	</a>
	<a href="https://github.com/signedsecurity/network-hacking-toolkit/blob/master/LICENSE">
		<img alt="GitHub" src="https://img.shields.io/github/license/signedsecurity/network-hacking-toolkit">
	</a>
</p>

<p align="center">
	<a href="https://hub.docker.com/r/signedsecurity/network-hacking-toolkit/">
		<img alt="Docker Automated build" src="https://img.shields.io/docker/automated/signedsecurity/network-hacking-toolkit">
	</a>
	<a href="https://hub.docker.com/r/signedsecurity/network-hacking-toolkit/">
		<img alt="Docker Pulls" src="https://img.shields.io/docker/pulls/signedsecurity/network-hacking-toolkit">
	</a>
	<a href="https://hub.docker.com/r/signedsecurity/network-hacking-toolkit/">
		<img alt="Docker Starts" src="https://img.shields.io/docker/stars/signedsecurity/network-hacking-toolkit">
	</a>
	<a href="https://hub.docker.com/r/signedsecurity/network-hacking-toolkit/">
		<img alt="Docker Image Size" src="https://img.shields.io/docker/image-size/signedsecurity/network-hacking-toolkit/latest">
	</a>
</p>

A network hacking toolkit docker image with GUI applications support.

## Resources

* [Installation](#installation)
    * [Docker](#docker)
    * [Docker Compose](#docker-compose)
    * [Build from Source](#build-from-source)
* [GUI Support](#gui-support)
    * [Using SSH with X11 forwarding](#using-ssh-with-x11-forwarding)
* [Installed](#installed)
    * [Tools](#tools)

## Installation

### Docker

Pull the image from Docker Hub:

```bash
docker pull signedsecurity/network-hacking-toolkit
```

Run a container and attach a shell:

```bash
docker run \
	-it \
	--rm \
	--shm-size="2g" \
	--name network-hacking-toolkit \
	--hostname network-hacking-toolkit \
	-p 22:22 \
	-v $(pwd)/data:/root/data \
	signedsecurity/network-hacking-toolkit \
	/bin/bash
```
### Docker Compose

Docker-Compose can also be used.

```yaml
version: "3.9"

services:
    network-hacking-toolkit:
        image: signedsecurity/network-hacking-toolkit
        container_name: network-hacking-toolkit
        hostname: network-hacking-toolkit
        stdin_open: true
        shm_size: 2gb # increase shared memory size to prevent firefox from crashing
        ports:
            - "22:22" # exposed for GUI support sing SSH with X11 forwarding
        volumes:
            - ./data:/root/data
        restart: unless-stopped
```

Build and run container:

```bash
docker-compose up
```

Attach shell:

```bash
docker-compose exec network-hacking-toolkit /bin/bash
```

### Build from Source

Clone this repository and build the image:

```bash
git clone https://github.com/signedsecurity/network-hacking-toolkit.git && \
cd network-hacking-toolkit && \
make build-image
```

Run a container and attach a shell:

```bash
make run
```

## GUI Support

By default, no GUI tools can be run in a Docker container as no X11 server is available. To run them, you must change that. What is required to do so depends on your host machine. If you:

* run on Linux, you probably have X11
* run on Mac OS, you need Xquartz (`brew install Xquartz`)
* run on Windows, you have a problem

### Using SSH with X11 forwarding

Use X11 forwarding through SSH if you want to go this way. Run `start_ssh` inside the container to start the server, make sure you expose port 22 when starting the container: `docker run -p 127.0.0.1:22:22 ...`, then use `ssh -X ...` when connecting (the script prints the password).

## Installed

### Tools

Many different Linux and Windows tools are installed. Windows tools are supported with Wine. Some tools can be used on the command line while others require GUI support!

| Category  | Name | Description |
| :-------- | :--- | :---------- |
| Utility/SHELL | [evil-winrm](https://github.com/Hackplayers/evil-winrm) | The ultimate WinRM shell for hacking/pentesting. |
| Discovery/DOMAIN | [grep](https://www.advanced-ip-scanner.com/) | Reliable and free network scanner to analyse LAN. The program shows all network devices, gives you access to shared folders, provides remote control of computers (via RDP and Radmin), and can even remotely switch computers off. It is easy to use and runs as a portable edition. It should be the first choice for every network admin. |
| Discovery/PORT | [masscan](https://github.com/robertdavidgraham/masscan) | TCP port scanner, spews SYN packets asynchronously, scanning entire Internet in under 5 minutes. . |
| Discovery/HOST | [netdiscover](https://github.com/netdiscover-scanner/netdiscover) | Netdiscover is a network address discovering tool, developed mainly for those wireless networks without dhcp server, it also works on hub/switched networks. Its based on arp packets, it will send arp requests and sniff for replies. |
| Discovery/PORT | [naabu](https://github.com/projectdiscovery/naabu) |  A fast port scanner written in go with a focus on reliability and simplicity. Designed to be used in combination with other tools for attack surface discovery in bug bounties and pentests. |
| Discovery/PORT | [nmap](https://nmap.org/) | Nmap ("Network Mapper") is a free and open source utility for network discovery and security auditing.|
| Discovery/PORT | [ps.sh](https://github.com/enenumxela/ps.sh) | A wrapper around tools used for port scanning(nmap, naabu & masscan), the goal being reducing scan time, increasing scan efficiency and automating the workflow. |
| Utility/MISC | [responder](https://github.com/lgandx/Responder) | Responder is an LLMNR, NBT-NS and MDNS poisoner.. |