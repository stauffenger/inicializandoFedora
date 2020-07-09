#!/bin/bash

echo 'Instalando drivers NVIDIA';
dnf install -yq nvidia-driver nvidia-driver-libs.i686 nvidia-settings akmod-nvidia cuda nvidia-driver-cuda --allowerasing --best ;