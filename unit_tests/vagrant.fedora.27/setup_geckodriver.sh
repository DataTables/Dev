#!/bin/sh

echo "Setting up geckodriver (Firefox)"

wget https://github.com/mozilla/geckodriver/releases/download/v0.22.0/geckodriver-v0.22.0-linux64.tar.gz
tar xzf geckodriver-v0.22.0-linux64.tar.gz

mv geckodriver /usr/bin
chmod 755 /usr/bin/geckodriver

rm geckodriver-v0.22.0-linux64.tar.gz

exit 0
