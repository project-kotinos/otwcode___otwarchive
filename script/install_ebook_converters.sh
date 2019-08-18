#!/bin/bash
set -ex

apt-get update -qq

# PDF
apt-get install -qq xfonts-75dpi xfonts-base gdebi-core libmysqlclient-dev
if [ ! -f libpng12-0_1.2.54-1ubuntu1.1_amd64.deb ]; then 
  wget http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
  gdebi --n ./libpng12-0_1.2.54-1ubuntu1.1_amd64.deb
  wget https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.xenial_amd64.deb
  gdebi --n ./wkhtmltox_0.12.5-1.xenial_amd64.deb
  wkhtmltopdf --version
fi

# Calibre
apt-get install -qq calibre
ebook-convert --version
