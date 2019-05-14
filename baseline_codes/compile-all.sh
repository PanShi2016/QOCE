#! /usr/bin/env bash

#编译(只需一次)
g++ -o ./code/run ./code/run.cpp

g++ -o ./algs/BIGCLAM/dataTran ./algs/BIGCLAM/dataTran.cpp

g++ -o ./algs/CFinder/CFinderWinLinux/CFtrans ./algs/CFinder/CFtrans.cpp
chmod +x algs/CFinder/CFinderWinLinux/CFinder_commandline
chmod +x algs/CFinder/CFinderWinLinux/CFinder_commandline64
