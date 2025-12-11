#!/bin/bash
cd ~/Documents/Hasdrubal
source venv/bin/activate
./hasdrubal_repl/gather_sources.sh
python hasdrubal_repl/hasdrubal_repl.py "$@"
