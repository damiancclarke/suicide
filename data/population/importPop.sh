#!/bin/bash

states="01 02 04 05 06 08 09 10 11 12 13 15 16 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 44 45 46 47 48 49 50 51 53 54 55 56" 

#2000-2010 Population data
mkdir 2000s
cd 2000s
for fip in $states; do
    echo "wgetting $fip"
    wget http://www.census.gov/popest/data/intercensal/county/files/CO-EST00INT-ALLDATA-$fip.csv 
done
cat * > pop2000-2010.csv

##1990-1999 Population data
mkdir ../1990s
cd ../1990s
for fip in $states; do
    echo "wgetting $fip"
    wget http://www.census.gov/popest/data/counties/asrh/1990s/tables/co-99-12/casrh$fip.txt
    echo "editing $fip"
    head -n -18 casrh$fip.txt > Int.txt
    tail -n +18 Int.txt > state$fip.txt
    rm Int.txt
done
cat state* > pop1990-1999.csv
    
