#!/bin/bash

echo 'Instalando drivers PostgreSQL Server 12';
dnf groupinstall -yq 'PostgreSQL Database Server 12 PGDG' --with-optional;

echo 'Instalando programas via dnf';
dnf install -yq code postgresql-server postgresql-contrib pgadmin4 npm golang;

echo 'Startando o postgres';
systemctl enable postgresql;
systemctl start postgresql;
postgresql-setup --initdb --unit postgresql;

echo 'Instalando programas via npm';
npm i -g npm;
npm i -g yarn;

echo 'Instalando programas via flatpak';
flatpak install -y flathub com.google.AndroidStudio --noninteractive;