#!/bin/bash

#exit on any errors
set -e

R_MAJOR_VERSION=3
R_VERSION=3.5.0
RSTUDIO_VERSION=1.1.453

# Install yum-utils for yum-builddep
sudo yum install -y wget 
sudo yum install -y yum-utils

sudo yum-builddep R
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel

# Required by R keyring package
sudo yum install -y libsecret-devel libsodium-devel

# Download R
wget https://cran.r-project.org/src/base/R-${R_MAJOR_VERSION}/R-${R_VERSION}.tar.gz
tar -xzf R-${R_VERSION}.tar.gz
cd R-${R_VERSION}
./configure --enable-R-shlib --with-blas --with-lapack
make
sudo make install
cd ..

# Download RStudio Server
wget https://download2.rstudio.org/rstudio-server-rhel-$RSTUDIO_VERSION-x86_64.rpm
# Install RStudio Server
sudo yum install -y --nogpgcheck rstudio-server-rhel-$RSTUDIO_VERSION-x86_64.rpm || true
# Stop yum from auto-updating R
echo "exclude=R-* R.x86* libR*"  | sudo tee -a /etc/yum.conf

# Start RStudio Server
sudo rstudio-server restart || true

