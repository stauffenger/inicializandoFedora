#!/bin/bash

echo 'Enabling NVIDIA repository.'
#nvidia
dnf config-manager --add-repo=https://negativo17.org/repos/fedora-nvidia.repo;