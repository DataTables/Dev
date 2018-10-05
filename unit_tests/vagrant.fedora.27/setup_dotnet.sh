#!/bin/sh

# .NET Core
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget -q https://packages.microsoft.com/config/fedora/27/prod.repo
sudo mv prod.repo /etc/yum.repos.d/microsoft-prod.repo
sudo chown root:root /etc/yum.repos.d/microsoft-prod.repo

sudo dnf install -y aspnetcore-runtime-2.1
sudo dnf install -y dotnet-sdk-2.1


# .NET Framework via Mono
sudo rpm --import "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
sudo curl https://download.mono-project.com/repo/centos7-stable.repo | sudo tee /etc/yum.repos.d/mono-centos7-stable.repo
sudo dnf install -y mono-devel mono-complete xsp msbuild


# Docfx for .NET code documentation generation
cd /vagrant
mkdir docfx
cd docfx
wget https://github.com/dotnet/docfx/releases/download/v2.39.2/docfx.zip
unzip docfx.zip
rm docfx.zip

