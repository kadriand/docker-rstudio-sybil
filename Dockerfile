# The first instruction is what image we want to base our container on We Use an official Python runtime as a parent image
FROM debian:stretch

# To install r-base
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE DontWarn

# install Django required packages
RUN apt-get update 
RUN apt-get install -y ca-certificates software-properties-common apt-transport-https gnupg2

# install R
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/'
COPY data /docker-req
RUN apt-key add /docker-req/rbase1.key
RUN apt update 
RUN apt -y install r-base r-base-core r-recommended r-base-dev
RUN apt-get install -y libxml2-dev build-essential libffi-dev libcurl4-openssl-dev libssl-dev lib32ncurses5-dev libreadline-dev libglpk-dev
RUN R --version

# Install libSBML
RUN tar -xxvf /docker-req/libSBML-5.17.0-core-plus-packages-src.* -C /docker-req \
	&& cd /docker-req/libSBML-5.17.0-Source \
	&& ./configure --prefix=/usr/local --enable-cpp-namespace --enable-fbc --enable-shared --with-gnu-ld --enable-layout --enable-comp --enable-qual --enable-groups --enable-compression --enable-shared-version \
	&& make \
	&& make install
RUN ldconfig
ENV DYLD_LIBRARY_PATH /usr/local/lib
ENV LD_LIBRARY_PATH /usr/local/lib

# Install Sybil R pacakges
RUN Rscript /docker-req/sybil_install.r

# Install RStudio Server
RUN apt-get install -y gdebi-core wget \
	&& wget https://download2.rstudio.org/rstudio-server-stretch-1.1.463-amd64.deb \
	&& gdebi --non-interactive rstudio-server-stretch-1.1.463-amd64.deb
RUN useradd -m -d /home/ruser -g rstudio-server ruser && echo ruser:rstudiopass | chpasswd

# Check RStudio Server installation
RUN dpkg -s rstudio-server
