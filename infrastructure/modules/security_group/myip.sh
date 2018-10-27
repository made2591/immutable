#!/bin/bash

IP=$(wget -qO- ipinfo.io/ip)

echo "{ \"ip\": \"${IP}\" }"
