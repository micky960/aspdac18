#aspdac18 
#aspdac18
 
Steps to follow to run the fault_atalanta.cpp file 
Main file is fault_atalanta.cpp 
Fault object is stored in fault_c.cpp
failing patterns objects are stored in patterns.cpp
parameters are saved in constants.h

cd /home/projects/aspdac/src/cpp/
1. make clean; make -j
2a. rm -rf path_link*
2b. setenv design des3_top_RTL

3. ./run_fa

4. Output is in ../../Results/$design/final/


vi /home/projects/aspdac18/src/cpp/constants.h 
SEC     - for key length
MAX_PAT - total number of failing pattern



Steps to follow:
1. obtain the locked netlist, along with the bench file using ./run_fa
2. obtain test patterns using Atalanta

